import 'package:flutter/material.dart';

class PassportPhotoScreen extends StatefulWidget {
  const PassportPhotoScreen({super.key});

  @override
  State<PassportPhotoScreen> createState() => _PassportPhotoScreenState();
}

enum PassportSize {
  india(35, 45, 'India / Schengen'),
  us(51, 51, 'US Passport / Visa'),
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

  final List<Color> _bgColors = [
    Colors.white,
    const Color(0xFFD6E6F5), // light blue
    const Color(0xFFE8E8E8), // grey
    const Color(0xFFC8F560), // lime accent
  ];

  final List<String> _bgNames = ['White', 'Light blue', 'Grey', 'Style'];

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
            // Size picker
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
            const SizedBox(height: 20),

            // Preview area
            const Text('Preview', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Center(
              child: AspectRatio(
                aspectRatio: ratio,
                child: Container(
                  decoration: BoxDecoration(
                    color: _bgColors[_bgIndex],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 80,
                        color: Colors.black.withOpacity(0.25),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload your photo below',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_size.widthMm.toInt()} × ${_size.heightMm.toInt()} mm',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Background picker
            const Text('Background', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: _bgColors.asMap().entries.map((e) {
                final selected = _bgIndex == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _bgIndex = e.key),
                    child: Column(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: e.value,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? const Color(0xFF7B4FCE) : Colors.white24,
                              width: selected ? 3 : 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _bgNames[e.key],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Coming next
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7B4FCE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF7B4FCE).withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFA78BFA), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Photo upload + AI cropping comes in the next update. For now, check out "Change Background" for AI-powered edits!',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Download button (placeholder)
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF7B4FCE),
                      content: Text('Photo upload coming in v0.4 next update'),
                    ),
                  );
                },
                child: const Text('Upload Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
