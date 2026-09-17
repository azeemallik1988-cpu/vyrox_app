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

  bool get _isBeta =>
      widget.mode == 'background' ||
      widget.mode == 'outfit' ||
      widget.mode == 'faceswap' ||
      widget.mode == 'upscale';

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

    // No probe. Just set the URL and let Image.network load it.
    final url = AiEnhanceEngine.buildEnhanceUrl(
      mode: widget.mode,
      referenceUrl: _uploadedUrl!,
      userPrompt: _promptController.text,
    );

    setState(() {
      _resultUrl = url;
      _generating = false;
      _error = null;
    });
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
      await Share.shareXFiles([XFile(file.path)], text: 'Enhanced with Vyrox AI ✨');
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
            // BETA warning banner
            if (_isBeta)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                ),
                child: const Row(children: [
                  Icon(Icons.science, color: Colors.orangeAccent, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Beta: free AI may not always keep your exact face. Results vary.',
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ),

            // IMAGE CARD
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

            Text(widget.title, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
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

            if (_uploading)
              _statusBox(icon: Icons.cloud_upload, color: const Color(0xFFA78BFA), text: 'Uploading photo...')
            else if (_error != null)
              _statusBox(icon: Icons.error_outline, color: Colors.redAccent, text: _error!),

            const SizedBox(height: 16),

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
                onPressed: (_uploading || _pickedImage == null) ? null : _generate,
                icon: _uploading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _pickedImage == null ? 'Pick a photo first' : 'Generate',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            if (_resultUrl != null) ...[
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
    if (_resultUrl != null) {
      return Image.network(
        _resultUrl!,
        key: ValueKey(_resultUrl),
        fit: BoxFit.cover,
        loadingBuilder: (c, child, p) => p == null ? child : _loadingPreview('Generating with AI...'),
        errorBuilder: (c, e, s) => _retryPreview(),
      );
    }
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

  Widget _retryPreview() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, color: Colors.redAccent, size: 40),
          const SizedBox(height: 12),
          const Text('Engine busy. Tap Generate again.', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _generate,
            child: const Text('Retry', style: TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold)),
          ),
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
