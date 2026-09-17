import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
  bool _downloading = false;
  String _statusMessage = 'Preparing...';
  final List<String> _failedEngines = [];
  final Random _random = Random();
  int _attemptId = 0;

  @override
  void initState() {
    super.initState();
    _saveProject();
    _runCascade();
  }

  Future<void> _saveProject() async {
    try {
      await AuthController.saveProject(
        title: widget.prompt.length > 40 ? '${widget.prompt.substring(0, 40)}...' : widget.prompt,
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

  /// Rich, distinct style recipes so each style looks truly different.
  String _styleRecipe(String base, String style) {
    switch (style.toLowerCase()) {
      case 'cinematic':
        return '$base, cinematic film still, dramatic movie lighting, shallow depth of field, '
            'anamorphic lens flare, moody color grading, teal and orange tones, '
            'shot on ARRI Alexa, 35mm film, professional cinematography, epic composition, 8k';
      case 'realistic':
        return '$base, ultra photorealistic, DSLR photograph, natural lighting, '
            'lifelike skin texture, sharp focus, high detail, shot on Canon EOS R5, '
            '85mm lens, realistic shadows, true-to-life colors, professional photography, 8k';
      case 'anime':
        return '$base, anime style, Studio Ghibli inspired, vibrant cel-shaded illustration, '
            'clean line art, expressive big eyes, colorful, Japanese animation, '
            'manga art style, detailed anime background, trending on pixiv, 4k';
      case 'noir':
        return '$base, film noir style, high contrast black and white, dramatic chiaroscuro lighting, '
            'deep shadows, moody atmosphere, 1940s detective aesthetic, '
            'monochrome, smoky ambiance, vintage cinematic, grainy film';
      default:
        return '$base, $style style, ultra detailed, high quality, 8k';
    }
  }

  Future<void> _runCascade() async {
    final engineMeta = allEngines.firstWhere((e) => e.id == _preferredEngine);
    if (engineMeta.requiresKey && !engineMeta.isReady) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _statusMessage = '${engineMeta.label} needs an API key.';
        });
      }
      return;
    }

    _attemptId++;
    final int myAttempt = _attemptId;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _imageUrl = null;
      _failedEngines.clear();
      _successEngine = null;
      _statusMessage = 'Starting...';
    });

    final cascade = buildCascadeOrder(_preferredEngine);
    for (int i = 0; i < cascade.length; i++) {
      if (!mounted || myAttempt != _attemptId) return;

      final engineId = cascade[i];
      final (w, h) = _dimensions();
      final seed = _random.nextInt(9999999);
      final enhanced = _styleRecipe(widget.prompt, widget.style);

      final url = buildPollinationsUrl(
        engineId: engineId,
        prompt: enhanced,
        width: w,
        height: h,
        seed: seed,
      );

      setState(() {
        _statusMessage = 'Loading ${engineId.toUpperCase()} (${i + 1}/${cascade.length})...';
        _imageUrl = url;
      });

      final ok = await _waitForImage(url, const Duration(seconds: 60));
      if (!mounted || myAttempt != _attemptId) return;

      if (ok) {
        setState(() {
          _successEngine = engineId.toUpperCase();
          _isLoading = false;
          _imageUrl = url;
        });
        return;
      } else {
        setState(() => _failedEngines.add(engineId.toUpperCase()));
        try {
          await NetworkImage(url).evict();
        } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }

    if (mounted && myAttempt == _attemptId) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _statusMessage = 'All engines failed. Retry in 30s.';
      });
    }
  }

  Future<bool> _waitForImage(String url, Duration timeout) async {
    final completer = Completer<bool>();
    final provider = NetworkImage(url);
    final stream = provider.resolve(ImageConfiguration.empty);

    late ImageStreamListener listener;
    bool done = false;

    void finish(bool ok) {
      if (done) return;
      done = true;
      stream.removeListener(listener);
      if (!completer.isCompleted) completer.complete(ok);
    }

    listener = ImageStreamListener(
      (info, sync) => finish(true),
      onError: (error, stack) => finish(false),
    );
    stream.addListener(listener);

    return completer.future.timeout(timeout, onTimeout: () {
      finish(false);
      return false;
    });
  }

  void _pickEngine(String id) {
    if (_preferredEngine == id) return;
    _preferredEngine = id;
    _runCascade();
  }

  void _openFullscreen() {
    if (_imageUrl == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenImageViewer(imageUrl: _imageUrl!, prompt: widget.prompt),
      ),
    );
  }

  Future<void> _downloadImage() async {
    if (_imageUrl == null || _downloading) return;
    setState(() => _downloading = true);
    try {
      final response = await http.get(Uri.parse(_imageUrl!));
      if (response.statusCode != 200) throw 'Download failed';
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'vyrox_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: const Color(0xFF10B981), content: Text('Saved: Documents/$filename'), duration: const Duration(seconds: 4)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text('Download failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _shareImage() async {
    if (_imageUrl == null) return;
    try {
      final response = await http.get(Uri.parse(_imageUrl!));
      if (response.statusCode != 200) throw 'Fetch failed';
      final dir = await getTemporaryDirectory();
      final filename = 'vyrox_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Created with Vyrox AI ✨\n"${widget.prompt}"');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text('Share failed: $e')),
        );
      }
    }
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
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _runCascade)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI Engine', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 78,
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
                      width: 96,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF7B4FCE).withOpacity(0.2) : const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: selected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.08), width: selected ? 1.5 : 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(eng.icon, size: 14, color: selected ? const Color(0xFFA78BFA) : Colors.white70),
                            const Spacer(),
                            if (locked) const Icon(Icons.lock, size: 10, color: Colors.orangeAccent),
                          ]),
                          Text(eng.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          Text(eng.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 8)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _openFullscreen,
              child: Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(
                  color: const Color(0xFF181228),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImageArea(),
                      if (_imageUrl != null && !_isLoading && !_hasError)
                        Positioned(
                          bottom: 12, right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
                            child: const Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.fullscreen, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text('Tap to view', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusBar(),
            const SizedBox(height: 16),
            if (_imageUrl != null && !_isLoading && !_hasError)
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.2)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _downloading ? null : _downloadImage,
                    icon: _downloading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.download, size: 20),
                    label: const Text('Download', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B4FCE),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: _shareImage,
                    icon: const Icon(Icons.share, size: 20),
                    label: const Text('Share', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            const SizedBox(height: 16),
            Row(children: [
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
            ]),
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
      decoration: BoxDecoration(color: borderColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildImageArea() {
    if (_hasError) return _errorWidget();
    if (_imageUrl == null) return _loadingWidget();
    return Image.network(
      _imageUrl!,
      key: ValueKey(_imageUrl),
      fit: BoxFit.cover,
      loadingBuilder: (c, child, p) => p == null ? child : _loadingWidget(),
      errorBuilder: (c, e, s) {
        if (!_hasError && !_isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _runCascade());
        }
        return _loadingWidget();
      },
    );
  }

  Widget _loadingWidget() => Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Color(0xFF7B4FCE)),
        const SizedBox(height: 20),
        Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        const Text('Free engines may take 10-60s', style: TextStyle(color: Colors.white38, fontSize: 12)),
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
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
        const SizedBox(height: 12),
        Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextButton(onPressed: _runCascade, child: const Text('Retry All Engines', style: TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold))),
      ],
    ),
  );

  Widget _buildStatusBar() {
    final loading = _isLoading;
    final color = _hasError ? Colors.redAccent : (loading ? const Color(0xFFA78BFA) : const Color(0xFF10B981));
    final icon = _hasError ? Icons.error_outline : (loading ? Icons.hourglass_top : Icons.check_circle);
    final msg = _hasError ? _statusMessage : (loading ? _statusMessage : 'Generated with $_successEngine · ${widget.style}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

class _FullscreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String prompt;
  const _FullscreenImageViewer({required this.imageUrl, required this.prompt});

  @override
  State<_FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<_FullscreenImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 5.0,
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (c, child, p) => p == null ? child : const Center(child: CircularProgressIndicator(color: Colors.white)),
            errorBuilder: (c, e, s) => const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 60)),
          ),
        ),
      ),
    );
  }
}
