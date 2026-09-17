import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum PassportSize {
  india(35, 45, 'India / Schengen (35x45mm)'),
  us(51, 51, 'US Passport / Visa (2x2 inch)'),
  uk(35, 45, 'UK / EU (35x45mm)'),
  china(33, 48, 'China Visa (33x48mm)');

  final double widthMm;
  final double heightMm;
  final String label;
  const PassportSize(this.widthMm, this.heightMm, this.label);
}

class PassportPhotoScreen extends StatefulWidget {
  const PassportPhotoScreen({super.key});

  @override
  State<PassportPhotoScreen> createState() => _PassportPhotoScreenState();
}

class _PassportPhotoScreenState extends State<PassportPhotoScreen> {
  File? _pickedImage;
  PassportSize _size = PassportSize.india;
  int _bgIndex = 0;
  bool _saving = false;
  final ImagePicker _picker = ImagePicker();

  final List<Color> _bgColors = [
    Colors.white,
    const Color(0xFFD6E6F5), // Light Blue
    const Color(0xFFE8E8E8), // Light Grey
    const Color(0xFF3B82F6), // Royal Blue
  ];

  final List<String> _bgNames = ['White', 'Light Blue', 'Grey', 'Royal Blue'];

  Future<void> _pickPhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );
      if (photo != null) {
        setState(() {
          _pickedImage = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.redAccent, content: Text('Error picking photo: $e')),
      );
    }
  }

  Future<void> _downloadOrShare() async {
    if (_pickedImage == null) return;
    setState(() => _saving = true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'passport_photo_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedFile = await _pickedImage!.copy('${dir.path}/$filename');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text('Saved: Documents/$filename'),
            duration: const Duration(seconds: 3),
          ),
        );
        await Share.shareXFiles([XFile(savedFile.path)], text: 'My Passport Photo created with Vyrox AI');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text('Failed to save: $e')),
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
        title: const Text('Passport Photo Maker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Size Selector
            const Text('Select Document Size', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
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
                    child: Text(
                      s.label,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Passport Photo Preview Frame
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: Container(
                      width: 220,
                      height: 220 / ratio,
                      decoration: BoxDecoration(
                        color: _bgColors[_bgIndex],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF7B4FCE), width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _pickedImage != null
                            ? Image.file(_pickedImage!, fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 48, color: Colors.black.withOpacity(0.4)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tap to add photo',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_size.widthMm.toInt()} x ${_size.heightMm.toInt()} mm',
                                    style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 11),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _pickedImage == null ? 'Tap box to pick face photo' : 'Tap image to change photo',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Background Color Picker
            const Text('Background Color', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _bgColors.asMap().entries.map((e) {
                final selected = _bgIndex == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => _bgIndex = e.key),
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: e.value,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? const Color(0xFF7B4FCE) : Colors.white24,
                              width: selected ? 3.5 : 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _bgNames[e.key],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Action Buttons
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
                onPressed: _pickedImage == null ? _pickPhoto : (_saving ? null : _downloadOrShare),
                icon: Icon(_pickedImage == null ? Icons.photo_library : Icons.download),
                label: Text(
                  _pickedImage == null ? 'Select Photo from Gallery' : 'Save & Share Passport Photo',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
