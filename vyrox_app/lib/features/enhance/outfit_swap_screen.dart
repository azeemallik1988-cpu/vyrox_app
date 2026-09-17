import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/engines/ai_engines.dart';

class OutfitSwapScreen extends StatefulWidget {
  const OutfitSwapScreen({super.key});

  @override
  State<OutfitSwapScreen> createState() => _OutfitSwapScreenState();
}

class _OutfitSwapScreenState extends State<OutfitSwapScreen> {
  File? _person;
  File? _garment;
  Uint8List? _resultBytes;
  bool _processing = false;
  bool _downloading = false;
  String? _error;
  int _categoryIndex = 0;

  final ImagePicker _picker = ImagePicker();
  final List<String> _categories = ['upper_body', 'lower_body', 'dresses'];
  final List<String> _categoryLabels = ['Top / Shirt', 'Pants / Lower', 'Dress / Full'];

  bool get _keyReady => EngineKeys.segmind.isNotEmpty;

  Future<File?> _pick() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1536,
        imageQuality: 90,
      );
      if (x == null) return null;
      return File(x.path);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickPerson() async {
    final f = await _pick();
    if (f != null) setState(() { _person = f; _resultBytes = null; _error = null; });
  }

  Future<void> _pickGarment() async {
    final f = await _pick();
    if (f != null) setState(() { _garment = f; _resultBytes = null; _error = null; });
  }

  Future<void> _tryOn() async {
    if (!_keyReady) {
      setState(() => _error = 'Add your free Segmind key in ai_engines.dart first.');
      return;
    }
    if (_person == null || _garment == null) {
      setState(() => _error = 'Pick both your photo and a clothing photo.');
      return;
    }

    setState(() {
      _processing = true;
      _error = null;
      _resultBytes = null;
    });

    try {
      final personB64 = base64Encode(await _person!.readAsBytes());
      final garmentB64 = base64Encode(await _garment!.readAsBytes());

      final response = await http.post(
        Uri.parse('https://api.segmind.com/v1/idm-vton'),
        headers: {
          'x-api-key': EngineKeys.segmind,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'human_img': personB64,
          'garm_img': garmentB64,
          'category': _categories[_categoryIndex],
          'crop': false,
          'seed': 42,
          'steps': 30,
          'base64': false,
        }),
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        setState(() {
          _resultBytes = response.bodyBytes;
          _processing = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _error = 'Invalid Segmind key. Check ai_engines.dart.';
          _processing = false;
        });
      } else if (response.statusCode == 406 || response.statusCode == 402) {
        setState(() {
          _error = 'Free credits used up today. Try again tomorrow.';
          _processing = false;
        });
      } else {
        setState(() {
          _error = 'Try-on failed (${response.statusCode}). Use a full-body photo + clear garment image.';
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
      final filename = 'vyrox_outfit_${DateTime.now().millisecondsSinceEpoch}.png';
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
      final filename = 'vyrox_outfit_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(_resultBytes!);
      await Share.shareXFiles([XFile(file.path)], text: 'Virtual try-on by Vyrox AI ✨');
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
        title: const Text('Change Outfit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  '🔑 Add your FREE Segmind key in ai_engines.dart to enable outfit try-on.',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),

            Row(
              children: [
                Expanded(child: _photoBox('Your photo', _person, _pickPerson, Icons.person)),
                const SizedBox(width: 12),
                Expanded(child: _photoBox('Clothing photo', _garment, _pickGarment, Icons.checkroom)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Left = full-body photo of you. Right = a clothing item photo.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 20),

            const Text('Clothing type', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _categoryLabels.asMap().entries.map((e) {
                final selected = _categoryIndex == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _categoryIndex = e.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF7B4FCE) : const Color(0xFF181228),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(e.value, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

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
                onPressed: _processing ? null : _tryOn,
                icon: _processing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.checkroom),
                label: Text(_processing ? 'Trying on... (up to 90s)' : 'Try On Outfit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tip: use a clear full-body photo + a garment on plain background for best results.',
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
        height: 180,
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
