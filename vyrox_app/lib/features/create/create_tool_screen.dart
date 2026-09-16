import 'package:flutter/material.dart';

class CreateToolScreen extends StatelessWidget {
  final String? tool;
  const CreateToolScreen({super.key, this.tool});

  @override
  Widget build(BuildContext context) {
    final String t = tool ?? 'Image';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF181228), borderRadius: BorderRadius.circular(24)),
              child: TextField(
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _hintFor(t),
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Options change per tool
            ..._optionsFor(t),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$t generating (mock) — real engine in Stage 4'), duration: const Duration(seconds: 2)),
                  );
                },
                child: Text('Generate $t', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _hintFor(String t) {
    switch (t) {
      case 'Video': return 'Describe your video scene...';
      case 'Sound': return 'Describe the sound or ambience...';
      case 'Music': return 'Describe the music mood, genre...';
      case 'Text': return 'What text do you want to generate?';
      case 'Avatar': return 'Describe your avatar...';
      case 'Upscale': return 'Upload or describe image to upscale...';
      case 'Remove BG': return 'Upload image to remove background...';
      default: return 'Describe what you want to create...';
    }
  }

  List<Widget> _optionsFor(String t) {
    if (t == 'Image' || t == 'Avatar') {
      return [
        _label('Style'),
        _chips(['Cinematic', 'Realistic', 'Anime', 'Noir']),
        const SizedBox(height: 16),
        _label('Aspect ratio'),
        _chips(['1:1', '16:9', '9:16']),
      ];
    }
    if (t == 'Video') {
      return [
        _label('Duration'),
        _chips(['5s', '10s', '15s']),
        const SizedBox(height: 16),
        _label('Aspect ratio'),
        _chips(['16:9', '9:16', '1:1']),
      ];
    }
    if (t == 'Music' || t == 'Sound') {
      return [
        _label('Genre'),
        _chips(['Ambient', 'Cinematic', 'Lo-fi', 'Epic']),
        const SizedBox(height: 16),
        _label('Length'),
        _chips(['30s', '1 min', '2 min']),
      ];
    }
    if (t == 'Text') {
      return [
        _label('Tone'),
        _chips(['Formal', 'Casual', 'Creative', 'Marketing']),
      ];
    }
    if (t == 'Upscale') {
      return [
        _label('Scale'),
        _chips(['2x', '4x', '8x']),
      ];
    }
    if (t == 'Remove BG') {
      return [
        _label('Output'),
        _chips(['Transparent', 'White', 'Black']),
      ];
    }
    return [];
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
  );

  Widget _chips(List<String> items) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: items.asMap().entries.map((e) {
      return ChoiceChip(
        label: Text(e.value),
        selected: e.key == 0,
        onSelected: (_) {},
        selectedColor: const Color(0xFF7B4FCE),
        labelStyle: const TextStyle(color: Colors.white),
        backgroundColor: const Color(0xFF181228),
      );
    }).toList(),
  );
}
