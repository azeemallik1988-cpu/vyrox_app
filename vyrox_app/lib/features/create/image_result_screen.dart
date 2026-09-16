import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/auth/auth_controller.dart';

// --- ENGINE DEFINITION ---
class _Engine {
  final String name;
  final String label;
  final String model;
  final Duration timeout;

  const _Engine({
    required this.name,
    required this.label,
    required this.model,
    required this.timeout,
  });

  String buildUrl({
    required String prompt,
    required String style,
    required int width,
    required int height,
    required int seed,
  }) {
    final enhanced = '$prompt, $style style, ultra detailed, high quality, 8k';
    final encoded = Uri.encodeComponent(enhanced);
    final modelParam = model.isEmpty ? '' : '&model=$model';
    return 'https://image.pollinations.ai/prompt/$encoded'
        '?width=$width&height=$height&nologo=true&seed=$seed$modelParam';
  }
}

const List<_Engine> _engines = [
  _Engine(name: 'FLUX', label: 'FLUX (high quality)', model: 'flux', timeout: Duration(seconds: 30)),
  _Engine(name: 'Turbo', label: 'Turbo (fast)', model: 'turbo', timeout: Duration(seconds: 20)),
  _Engine(name: 'Kontext', label: 'Kontext', model: 'kontext', timeout: Duration(seconds: 25)),
  _Engine(name: 'Default', label: 'Auto', model: '', timeout: Duration(seconds: 25)),
];

class ImageResultScreen extends StatefulWidget {
  final String prompt;
  final String style;
  final String aspectRatio;

  const ImageResultScreen({
    super.key,
    required this.prompt,
    required this.style,
    required this.aspectRatio,
  });

  @override
  State<ImageResultScreen> createState() => _ImageResultScreenState();
}

class _ImageResultScreenState extends State<ImageResultScreen> {
  String? _imageUrl;
  bool _isLoading = true;
  bool _hasError = false;
  bool _savedToDb = false;

  // Engine tracking
  int _currentEngineIndex = 0;
  String _statusMessage = 'Preparing engines...';
  final List<String> _failedEngines = [];
  String? _successEngine;

  @override
  void initState() {
    super.initState();
    _saveProject();
    _runEngineCascade();
  }

  Future<void> _saveProject() async {
    try {
      await AuthController.saveProject(
        title: widget.prompt.length > 40
            ? '${widget.prompt.substring(0, 40)}...'
            : widget.prompt,
        kind: 'image',
      );
      if (mounted) setState(() => _savedToDb = true);
    } catch (_) {
      // Silent fail
    }
  }

  Future<void> _runEngineCascade() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _imageUrl = null;
      _failedEngines.clear();
      _successEngine = null;
    });

    // Get dimensions
    int width = 1024;
    int height = 1024;
    if (widget.aspectRatio == '16:9') {
      width = 1280;
      height = 720;
    } else if (widget.aspectRatio == '9:16') {
      width = 720;
      height = 1280;
    }

    final seed = Random().nextInt(999999);

    // Try each engine in order
    for (int i = 0; i < _engines.length; i++) {
      final engine = _engines[i];

      if (!mounted) return;

      setState(() {
        _currentEngineIndex = i;
        _statusMessage = 'Trying engine ${i + 1} of ${_engines.length} · ${engine.label}';
      });

      final url = engine.buildUrl(
        prompt: widget.prompt,
        style: widget.style,
        width: width,
        height: height,
        seed: seed,
      );

      final ok = await _testEngine(url, engine.timeout);

      if (!mounted) return;

      if (ok) {
        setState(() {
          _imageUrl = url;
          _successEngine = engine.name;
          _isLoading = false;
        });
        return;
      } else {
        setState(() {
          _failedEngines.add(engine.name);
        });
      }
    }

    // All engines failed
    if (mounted) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _statusMessage = 'All engines failed';
      });
    }
  }

  /// Tests if the engine URL responds with a valid image within the timeout.
  Future<bool> _testEngine(String url, Duration timeout) async {
    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = timeout;

      final uri = Uri.parse(url);
      final request = await client.getUrl(uri).timeout(timeout);
      final response = await request.close().timeout(timeout);

      if (response.statusCode == 200) {
        // Read headers to verify image type
        final contentType = response.headers.contentType?.mimeType ?? '';
        await response.drain();
        return contentType.startsWith('image/') || contentType.isEmpty;
      }

      await response.drain();
      return false;
    } catch (_) {
      return false;
    } finally {
      client?.close(force: true);
    }
  }

  void _regenerate() => _runEngineCascade();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Result', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _regenerate,
            tooltip: 'Regenerate',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE AREA
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 320),
              decoration: BoxDecoration(
                color: const Color(0xFF181228),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _buildImageArea(),
              ),
            ),
            const SizedBox(height: 16),

            // ENGINE STATUS BAR
            if (_isLoading)
              _buildStatusBar()
            else if (_hasError)
              _buildErrorStatusBar()
            else if (_successEngine != null)
              _buildSuccessStatusBar(),

            const SizedBox(height: 16),

            // META BADGES
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B4FCE).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.style,
                    style: const TextStyle(color: Color(0xFFA78BFA), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.aspectRatio,
                    style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                if (_savedToDb)
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                      SizedBox(width: 4),
                      Text('Saved', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),

            const Text('Prompt', style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(widget.prompt, style: const TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 28),

            // ACTIONS
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                onPressed: _isLoading ? null : _regenerate,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome),
                    SizedBox(width: 8),
                    Text('Regenerate (all engines)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.15)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Edit Prompt', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    if (_hasError) return _errorWidget();
    if (_isLoading || _imageUrl == null) return _loadingWidget();

    return Image.network(
      _imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _loadingWidget();
      },
      errorBuilder: (context, error, stack) {
        // If image fails after perceived success, auto-retry cascade
        WidgetsBinding.instance.addPostFrameCallback((_) => _runEngineCascade());
        return _loadingWidget();
      },
    );
  }

  Widget _loadingWidget() {
    return Container(
      height: 320,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF7B4FCE)),
          const SizedBox(height: 20),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          const Text(
            'Free engines may take 5-30 seconds',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          if (_failedEngines.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: _failedEngines
                  .map((name) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '✕ $name',
                          style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      height: 320,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          const Text('All engines failed',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Free tier may be busy. Try again in 30 seconds.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _regenerate,
            child: const Text('Retry All Engines',
                style: TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF7B4FCE).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7B4FCE).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(color: Color(0xFFA78BFA), strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _statusMessage,
              style: const TextStyle(color: Color(0xFFA78BFA), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Generated with $_successEngine engine',
              style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          if (_failedEngines.isNotEmpty)
            Text(
              '(skipped ${_failedEngines.length})',
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tried ${_failedEngines.length} engines · all failed',
              style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
