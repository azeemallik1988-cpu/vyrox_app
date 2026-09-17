import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/engines/ai_engines.dart';

class FaceSwapScreen extends StatefulWidget {
  const FaceSwapScreen({super.key});

  @override
  State<FaceSwapScreen> createState() => _FaceSwapScreenState();
}

class _FaceSwapScreenState extends State<FaceSwapScreen> {
  File? _sourceFace; // the face you want to use
  File? _targetImage; // the photo to put the face onto
  Uint8List? _resultBytes;
  bool _processing = false;
  String? _error;
  bool _downloading = false;

  final ImagePicker _picker = ImagePicker();

  bool get _keyReady => EngineKeys.segmind.isNotEmpty;

  Future<File?> _pick() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );
      if (x == null) return null;
      return File(x.path);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickSource() async {
    final f = await _pick();
    if (f != null) setState(() { _sourceFace = f; _resultBytes = null; _error = null; });
  }

  Future<void> _pickTarget() async {
    final f = await _pick();
    if (f != null) setState(() { _targetImage = f; _resultBytes = null; _error = null; });
  }

  Future<void> _swap() async {
    if (!_keyReady) {
      setState(() => _error = 'Add your free Segmind key in ai_engines.dart first.');
      return;
    }
    if (_sourceFace == null || _targetImage == null) {
      setState(() => _error = 'Pick both photos first.');
      return;
    }

    setState(() {
      _processing = true;
      _error = null;
      _resultBytes = null;
    });

    try {
      final sourceB64 = base64Encode(await _sourceFace!.readAsBytes());
      final targetB64 = base64Encode(await _targetImage!.readAsBytes());

      final response = await http.post(
        Uri.parse('https://api.segmind.com/v1/faceswap-v2'),
        headers: {
          'x-api-key': EngineKeys.segmind,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'source_img': sourceB64,
          'target_img': targetB64,
          'input_faces_index': 0,
          'source_faces_index': 0,
          'face_restore': 'codeformer-v0.1.0.pth',
          'base64': false,
        }),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        setState(() {
          _resultBytes = response.bodyBytes;
          _processing = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _error = 'Invalid Segmind key. Check it in ai_engines.dart.';
          _processing = false;
        });
      } else if (response.statusCode == 406 || response.statusCode == 402) {
        setState(() {
          _error = 'Free credits used up for today. Try again tomorrow.';
          _processing = false;
        });
      } else {
        setState(() {
          _error = 'Swap failed (${response.statusCode}). Try clearer front-facing photos.';
          _processing = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _processing = false;
      });
    }
  }

  Future<void> _download() async {
    if (_resultBytes == null || _downloading) return;
    setState(() => _downloading = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'vyrox_faceswap_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(_resultBytes!);
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

  Future<void> _share() async {
    if (_resultBytes == null) return;
    try {
      final dir = await getTemporaryDirectory();
      final filename = 'vyrox_faceswap_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(_resultBytes!);
      await Share.shareXFiles([XFile(file.path)], text: 'Face swap by Vyrox AI ✨');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Face Swap', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_keyReady)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                ),
                child: const Text(
                  '🔑 Add your FREE Segmind key in ai_engines.dart to enable face swap. Get it at segmind.com (2-min signup).',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),

            // Two photo pickers
            Row(
              children: [
                Expanded(child: _photoBox('Face to use', _sourceFace, _pickSource, Icons.face)),
                const SizedBox(width: 12),
                Expanded(child: _photoBox('Target photo', _targetImage, _pickTarget, Icons.person)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Left = the face you want. Right = the photo to place it on.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 20),

            // Result
            if (_resultBytes != null) ...[
              const Text('Result', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(_resultBytes!, width: double.infinity, fit: BoxFit.cover),
              ),
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
                    icon: _downloading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.download, size: 20),
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
              const SizedBox(height: 16),
            ],

            if (_error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600))),
                ]),
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                onPressed: _processing ? null : _swap,
                icon: _processing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.swap_horiz),
                label: Text(_processing ? 'Swapping faces...' : 'Swap Faces', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tip: use clear, front-facing photos with good lighting for best results.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoBox(String label, File? file, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF181228),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: file != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(file, fit: BoxFit.cover, width: double.infinity),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 36, color: Colors.white38),
                  const SizedBox(height: 10),
                  Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Tap to pick', style: TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
      ),
    );
  }
}
