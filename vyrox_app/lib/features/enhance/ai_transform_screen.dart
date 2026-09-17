import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/engines/ai_enhance_engine.dart';

class AITransformScreen extends StatefulWidget {
  final String mode;
  final String title;

  const AITransformScreen({
    super.key,
    required this.mode,
    required this.title,
  });

  @override
  State<AITransformScreen> createState() => _AITransformScreenState();
}

class _AITransformScreenState extends State<AITransformScreen> {
  File? _pickedImage;
  String? _uploadedUrl;
  String? _resultUrl;
  bool _uploading = false;
  bool _generating = false;
  bool _downloading = false;
  String? _error;
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 88,
      );
      if (picked == null) return;

      setState(() {
        _pickedImage = File(picked.path);
        _uploadedUrl = null;
        _resultUrl = null;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Could not open gallery: $e');
    }
  }

  Future<bool> _ensureUploaded() async {
    if (_uploadedUrl != null) return true;
    if (_pickedImage == null) return false;

    setState(() {
      _uploading = true;
      _error = null;
    });

    final url = await AiEnhanceEngine.uploadImage(_pickedImage!);

    if (!mounted) return false;

    setState(() => _uploading = false);

    if (url == null) {
      setState(() => _error = 'Upload failed. Check internet and try again.');
      return false;
    }

    _uploadedUrl = url;
    return true;
  }

  Future<void> _generate() async {
    if (_pickedImage == null) {
      setState(() => _error = 'Pick a photo first');
      return;
    }

    final ok = await _ensureUploaded();
    if (!ok) return;

    setState(() {
      _generating = true;
      _error = null;
      _resultUrl = null;
    });

    final url = AiEnhanceEngine.buildEnhanceUrl(
      mode: widget.mode,
      referenceUrl: _uploadedUrl!,
      userPrompt: _promptController.text,
    );

    // Wait until the image actually loads (60s timeout)
    final loaded = await _waitForImage(url, const Duration(seconds: 60));

    if (!mounted) return;

    if (loaded) {
      setState(() {
        _resultUrl = url;
        _generating = false;
      });
    } else {
      setState(() {
        _error = 'Engine is busy. Wait 20s and try again.';
        _generating = false;
      });
    }
  }

  /// Waits for a NetworkImage URL to fully resolve (or timeout).
  /// Returns true if it loaded successfully, false otherwise.
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

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        finish(false);
        return false;
      },
    );
  }

  Future<void> _download() async {
    if (_resultUrl == null || _downloading) return;
    setState(() => _downloading = true);
    try {
      final response = await http.get(Uri.parse(_resultUrl!));
      if (response.statusCode != 200) throw 'Download failed';
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'vyrox_${widget.mode}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text('Saved: Documents/$filename'),
            duration: const Duration(seconds: 4),
          ),
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

  Future<void> _share() async {
    if (_resultUrl == null) return;
    try {
      final response = await http.get(Uri.parse(_resultUrl!));
      if (response.statusCode != 200) throw 'Fetch failed';
      final dir = await getTemporaryDirectory();
      final filename = 'vyrox_${widget.mode}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Enhanced with Vyrox AI ✨',
      );
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
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SOURCE / RESULT IMAGE CARD
            GestureDetector(
              onTap: _pickedImage == null ? _pickImage : null,
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
                  child: _buildPreview(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Change photo button
            if (_pickedImage != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library, size: 18),
                  label: const Text('Choose different photo', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            const SizedBox(height: 20),

            // PROMPT FIELD
            Text(
              AiEnhanceEngine.titleFor(widget.mode),
              style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF181228),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: TextField(
                controller: _promptController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AiEnhanceEngine.hintFor(widget.mode),
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // STATUS / ERROR
            if (_uploading)
              _statusBox(icon: Icons.cloud_upload, color: const Color(0xFFA78BFA), text: 'Uploading photo to AI...')
            else if (_generating)
              _statusBox(icon: Icons.auto_awesome, color: const Color(0xFF7B4FCE), text: 'Generating your edit...')
            else if (_error != null)
              _statusBox(icon: Icons.error_outline, color: Colors.redAccent, text: _error!),

            const SizedBox(height: 16),

            // GENERATE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                onPressed: (_uploading || _generating || _pickedImage == null) ? null : _generate,
                icon: _uploading || _generating
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _pickedImage == null ? 'Pick a photo first' : 'Generate ${widget.title}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // RESULT ACTIONS
            if (_resultUrl != null && !_generating) ...[
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.2)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _downloading ? null : _download,
                    icon: _downloading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.download, size: 20),
                    label: const Text('Download', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: _share,
                    icon: const Icon(Icons.share, size: 20),
                    label: const Text('Share', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_resultUrl != null && !_generating) {
      return Image.network(
        _resultUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (c, child, p) => p == null ? child : _loadingPreview('Loading result...'),
        errorBuilder: (c, e, s) => _loadingPreview('Result failed to load'),
      );
    }

    if (_generating) return _loadingPreview('Generating with AI...');

    if (_pickedImage != null) {
      return Image.file(_pickedImage!, fit: BoxFit.cover);
    }

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add_photo_alternate_outlined, size: 60, color: Colors.white24),
          SizedBox(height: 14),
          Text('Tap to pick a photo', style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('From your gallery', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _loadingPreview(String text) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF7B4FCE)),
          const SizedBox(height: 20),
          Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          const Text('Free AI · 15-60 seconds', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _statusBox({required IconData icon, required Color color, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
