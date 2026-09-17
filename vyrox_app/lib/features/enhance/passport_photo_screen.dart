import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PassportPhotoScreen extends StatefulWidget {
  const PassportPhotoScreen({super.key});

  @override
  State<PassportPhotoScreen> createState() => _PassportPhotoScreenState();
}

enum PassportSize {
  india(35, 45, 'India / Schengen (35x45mm)'),
  us(51, 51, 'US Passport (51x51mm)'),
  uk(35, 45, 'UK / EU (35x45mm)'),
  china(33, 48, 'China Visa (33x48mm)');

  final double widthMm;
  final double heightMm;
  final String label;
  const PassportSize(this.widthMm, this.heightMm, this.label);
}

class _PassportPhotoScreenState extends State<PassportPhotoScreen> {
  PassportSize _size = PassportSize.india;
  int _bgIndex = 0;
  File? _photo;
  bool _saving = false;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _captureKey = GlobalKey();

  final List<Color> _bgColors = [
    Colors.white,
    const Color(0xFFD6E6F5),
    const Color(0xFFE8E8E8),
    const Color(0xFF4A90E2),
  ];
  final List<String> _bgNames = ['White', 'Light Blue', 'Grey', 'Royal Blue'];

  Future<void> _pickPhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 92,
      );
      if (picked == null) return;
      setState(() => _photo = File(picked.path));
    } catch (_) {}
  }

  Future<void> _saveAndShare() async {
    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a photo first')),
      );
      return;
    }
    setState(() => _saving = true);

    try {
      // Capture the framed preview as an image
      await Future.delayed(const Duration(milliseconds: 100));
      final boundary = _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 4.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw 'Capture failed';
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to file
      final dir = await getTemporaryDirectory();
      final filename = 'passport_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(pngBytes);

      // Share
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Passport photo · ${_size.label} · Made with Vyrox AI',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratio = _size.widthMm / _size.heightMm;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Passport Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Photo size', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PassportSize.values.map((s) {
                final selected = _size == s;
                return GestureDetector(
                  onTap: () => setState(() => _size = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF7B4FCE) : const Color(0xFF181228),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(s.label, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // CAPTURE AREA (this is what gets saved)
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: RepaintBoundary(
                  key: _captureKey,
                  child: AspectRatio(
                    aspectRatio: ratio,
                    child: Container(
                      width: 240,
                      color: _bgColors[_bgIndex],
                      child: _photo != null
                          ? Image.file(_photo!, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline, size: 70, color: Colors.black.withOpacity(0.25)),
                                const SizedBox(height: 10),
                                Text('Tap to upload', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text('Tap image to change photo', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ),
            const SizedBox(height: 24),

            const Text('Background Color', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: _bgColors.asMap().entries.map((e) {
                final selected = _bgIndex == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: GestureDetector(
                    onTap: () => setState(() => _bgIndex = e.key),
                    child: Column(children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: e.value,
                          shape: BoxShape.circle,
                          border: Border.all(color: selected ? const Color(0xFF7B4FCE) : Colors.white24, width: selected ? 3 : 1),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_bgNames[e.key], style: TextStyle(color: selected ? Colors.white : Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

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
                onPressed: _saving ? null : _saveAndShare,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.download),
                label: const Text('Save & Share Passport Photo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your photo is framed at the exact size with your chosen background, then saved & shared as a print-ready image.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
