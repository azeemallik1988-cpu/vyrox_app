import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PassportPhotoScreen extends StatefulWidget {
  const PassportPhotoScreen({super.key});

  @override
  State<PassportPhotoScreen> createState() => _PassportPhotoScreenState();
}

enum PassportSize {
  india(35, 45, 'India / Schengen'),
  us(51, 51, 'US Passport'),
  uk(35, 45, 'UK / EU'),
  china(33, 48, 'China Visa');

  final double widthMm;
  final double heightMm;
  final String label;
  const PassportSize(this.widthMm, this.heightMm, this.label);
}

class _PassportPhotoScreenState extends State<PassportPhotoScreen> {
  PassportSize _size = PassportSize.india;
  int _bgIndex = 0;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  final List<Color> _bgColors = [
    Colors.white,
    const Color(0xFFD6E6F5),
    const Color(0xFFE8E8E8),
    const Color(0xFFC8F560),
  ];
  final List<String> _bgNames = ['White', 'Light blue', 'Grey', 'Style'];

  Future<void> _pickPhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 90,
      );
      if (picked == null) return;
      setState(() => _photo = File(picked.path));
    } catch (_) {}
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
            const SizedBox(height: 20),

            const Text('Preview', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Center(
              child: AspectRatio(
                aspectRatio: ratio,
                child: Container(
                  decoration: BoxDecoration(
                    color: _bgColors[_bgIndex],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _photo != null
                        ? Image.file(_photo!, fit: BoxFit.cover)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline, size: 70, color: Colors.black.withOpacity(0.25)),
                              const SizedBox(height: 10),
                              Text('Upload your photo below', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text('${_size.widthMm.toInt()} × ${_size.heightMm.toInt()} mm', style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 10)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Background', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: _bgColors.asMap().entries.map((e) {
                final selected = _bgIndex == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _bgIndex = e.key),
                    child: Column(children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: e.value,
                          shape: BoxShape.circle,
                          border: Border.all(color: selected ? const Color(0xFF7B4FCE) : Colors.white24, width: selected ? 3 : 1),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_bgNames[e.key], style: TextStyle(color: selected ? Colors.white : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
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
                onPressed: _pickPhoto,
                icon: const Icon(Icons.photo_library),
                label: Text(_photo == null ? 'Upload Photo' : 'Change Photo', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Preview shows your photo at the selected size & background. AI auto-cropping (head alignment) comes next update.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
