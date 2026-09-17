import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../../core/engines/ai_enhance_engine.dart';

class FaceSwapScreen extends StatefulWidget {
  const FaceSwapScreen({super.key});

  @override
  State<FaceSwapScreen> createState() => _FaceSwapScreenState();
}

class _FaceSwapScreenState extends State<FaceSwapScreen> {
  File? _faceImage;
  File? _targetImage;
  String? _resultUrl;
  bool _uploading = false;
  bool _generating = false;
  bool _downloading = false;
  String? _error;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFace) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 88,
      );
      if (picked == null) return;

      setState(() {
        if (isFace) {
          _faceImage = File(picked.path);
        } else {
          _targetImage = File(picked.path);
        }
        _resultUrl = null;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Could not pick image: $e');
    }
  }

  Future<void> _handleFaceSwap() async {
    if (_faceImage == null || _targetImage == null) {
      setState(() => _error = 'Please upload BOTH your face photo and target body photo.');
      return;
    }

    setState(() {
      _uploading = true;
      _generating = false;
      _error = null;
      _resultUrl = null;
    });

    // Upload target image to server
    final targetUrl = await AiEnhanceEngine.uploadImage(_targetImage!);

    if (!mounted) return;

    if (targetUrl == null) {
      setState(() {
        _uploading = false;
        _error = 'Failed to upload photo. Check internet connection.';
      });
      return;
    }

    setState(() {
      _uploading = false;
      _generating = true;
    });

    final url = AiEnhanceEngine.buildEnhanceUrl(
      mode: 'faceswap',
      referenceUrl: targetUrl,
      userPrompt: 'swap face seamlessly, realistic high quality portrait',
    );

    // Wait for AI generation
    final ok = await _waitForImage(url, const Duration(seconds: 60));

    if (!mounted) return;

    if (ok) {
      setState(() {
        _resultUrl = url;
        _generating = false;
      });
    } else {
      setState(() {
        _generating = false;
        _error = 'Free AI engine busy. Please wait 15 seconds and tap Swap Face again.';
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

  Future<void> _download() async {
    if (_resultUrl == null || _downloading) return;
    setState(() => _downloading = true);
    try {
      final response = await http.get(Uri.parse(_resultUrl!));
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'faceswap_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: const Color(0xFF10B981), content: Text('Saved: Documents/$filename')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('AI Face Swap', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Two Slots Row
            Row(
              children: [
                // Slot 1: Your Face
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _faceImage != null ? const Color(0xFF7B4FCE) : Colors.white24, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: _faceImage != null
                            ? Image.file(_faceImage!, fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.face, size: 36, color: Color(0xFF7B4FCE)),
                                  SizedBox(height: 8),
                                  Text('1. Your Face', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text('Selfie photo', style: TextStyle(color: Colors.white38, fontSize: 10)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.swap_horiz, color: Color(0xFFC8F560), size: 28),
                const SizedBox(width: 12),
                // Slot 2: Target Image
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(false),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _targetImage != null ? const Color(0xFF7B4FCE) : Colors.white24, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: _targetImage != null
                            ? Image.file(_targetImage!, fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.photo, size: 36, color: Color(0xFF10B981)),
                                  SizedBox(height: 8),
                                  Text('2. Target Body', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text('Body or scene', style: TextStyle(color: Colors.white38, fontSize: 10)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Result Display Card
            if (_resultUrl != null) ...[
              const Text('Face Swap Result', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF181228),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF10B981), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(_resultUrl!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: _downloading ? null : _download,
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text('Download Result', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Status message
            if (_uploading)
              _statusBox('Uploading photos to AI engine...')
            else if (_generating)
              _statusBox('Swapping face... Please wait 20-40 seconds...')
            else if (_error != null)
              _errorBox(_error!),

            const SizedBox(height: 20),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: (_uploading || _generating) ? null : _handleFaceSwap,
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                  _generating ? 'Processing Swap...' : 'Swap Face Now',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBox(String text) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFF7B4FCE).withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Color(0xFFA78BFA), strokeWidth: 2)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFA78BFA), fontSize: 13, fontWeight: FontWeight.bold))),
        ]),
      );

  Widget _errorBox(String text) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
        child: Text(text, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
      );
}
