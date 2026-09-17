import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/auth/auth_controller.dart';
import '../../core/engines/ai_engines.dart';

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
  String _preferredEngine = 'auto';
  String? _imageUrl;
  String? _successEngine;
  bool _isLoading = true;
  bool _hasError = false;
  bool _savedToDb = false;
  String _statusMessage = 'Preparing...';
  final List<String> _failedEngines = [];

  @override
  void initState() {
    super.initState();
    _saveProject();
    _runCascade();
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
    } catch (_) {}
  }

  (int, int) _dimensions() {
    if (widget.aspectRatio == '16:9') return (1280, 720);
    if (widget.aspectRatio == '9:16') return (720, 1280);
    return (1024, 1024);
  }

  Future<void> _runCascade() async {
    // Block key-locked engines if not configured
    final engineMeta = allEngines.firstWhere((e) => e.id == _preferredEngine);
    if (engineMeta.requiresKey && !engineMeta.isReady) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _statusMessage =
              '${engineMeta.label} needs an API key. Add it in ai_engines.dart, or pick a free engine.';
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _imageUrl = null;
      _failedEngines.clear();
      _successEngine = null;
    });

    final (w, h) = _dimensions();
    final seed = Random().nextInt(999999);
    final cascade = buildCascadeOrder(_preferredEngine);
    final enhanced =
        '${widget.prompt}, ${widget.style} style, ultra detailed, high quality, 8k';

    for (int i = 0; i < cascade.length; i++) {
      final engineId = cascade[i];
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Trying ${engineId.toUpperCase()} (${i + 1}/${cascade.length})...';
      });

      final url = buildPollinationsUrl(
        engineId: engineId,
        prompt: enhanced,
        width: w,
        height: h,
        seed: seed,
      );

      final ok = await _probe(url);

      if (!mounted) return;

      if (ok) {
        setState(() {
          _imageUrl = url;
          _successEngine = engineId.toUpperCase();
          _isLoading = false;
        });
        return;
      } else {
        setState(() => _failedEngines.add(engineId.toUpperCase()));
      }
    }

    if (mounted) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _statusMessage = 'All engines failed';
      });
    }
  }

  Future<bool> _probe(String url) async {
    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);
      final request = await client.getUrl(Uri.parse(url)).timeout(const Duration(seconds: 35));
      final response = await request.close().timeout(const Duration(seconds: 35));
      if (response.statusCode == 200) {
        await response.drain();
        return true;
      }
      await response.drain();
      return false;
    } catch (_) {
      return false;
    } finally {
      client?.close(force: true);
    }
  }

  void _pickEngine(String id) {
    if (_preferredEngine == id) return;
    _preferredEngine = id;
    _runCascade();
  }

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
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _runCascade),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI Engine', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: allEngines.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final eng = allEngines[i];
                  final selected = _preferredEngine == eng.id;
                  final locked = eng.requiresKey && !eng.isReady;
                  return GestureDetector(
                    onTap: () => _pickEngine(eng.id),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF7B4FCE).withOpacity(0.2) : const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.08),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(eng.icon, size: 16, color: selected ? const Color(0xFFA78BFA) : Colors.white70),
                              const Spacer(),
                              if (locked) const Icon(Icons.lock, size: 12, color: Colors.orangeAccent),
                            ],
                          ),
                          Text(
                            eng.label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            eng.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white54, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

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

            _buildStatusBar(),

            const SizedBox(height: 16),
            Row(
              children: [
                _badge(widget.style, const Color(0xFFA78BFA), const Color(0xFF7B4FCE)),
                const SizedBox(width: 8),
                _badge(widget.aspectRatio, Colors.white60, Colors.white),
                const Spacer(),
                if (_savedToDb)
                  const Row(children: [
                    Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                    SizedBox(width: 4),
                    Text('Saved', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Prompt', style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(widget.prompt, style: const TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 24),
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
                onPressed: _isLoading ? null : _runCascade,
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('Regenerate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color textColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: borderColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildImageArea() {
    if (_hasError) return _errorWidget();
    if (_isLoading || _imageUrl == null) return _loadingWidget();
    return Image.network(
      _imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (c, child, p) => p == null ? child : _loadingWidget(),
      errorBuilder: (c, e, s) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _runCascade());
        return _loadingWidget();
      },
    );
  }

  Widget _loadingWidget() => Container(
    height: 320,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Color(0xFF7B4FCE)),
        const SizedBox(height: 20),
        Text(_statusMessage, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        const Text('Free engines may take 5-30s', style: TextStyle(color: Colors.white38, fontSize: 12)),
        if (_failedEngines.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            children: _failedEngines.map((n) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Text('✕ $n', style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
        ],
      ],
    ),
  );

  Widget _errorWidget() => Container(
    height: 320,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
        const SizedBox(height: 12),
        Text(_statusMessage, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextButton(onPressed: _runCascade, child: const Text('Retry', style: TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold))),
      ],
    ),
  );

  Widget _buildStatusBar() {
    final loading = _isLoading;
    final color = _hasError ? Colors.redAccent : (loading ? const Color(0xFFA78BFA) : const Color(0xFF10B981));
    final icon = _hasError ? Icons.error_outline : (loading ? Icons.hourglass_top : Icons.check_circle);
    final msg = _hasError
        ? _statusMessage
        : (loading ? _statusMessage : 'Generated with $_successEngine');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
