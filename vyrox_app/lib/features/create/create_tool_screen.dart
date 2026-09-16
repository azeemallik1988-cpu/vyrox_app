import 'package:flutter/material.dart';

class CreateToolScreen extends StatefulWidget {
  final String? tool;
  const CreateToolScreen({super.key, this.tool});

  @override
  State<CreateToolScreen> createState() => _CreateToolScreenState();
}

class _CreateToolScreenState extends State<CreateToolScreen> {
  late String _tool;
  int _selectedOption1 = 0;
  int _selectedOption2 = 0;
  final TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tool = widget.tool ?? 'Image';
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _tool,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt input box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF181228),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: TextField(
                controller: _promptController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _hintFor(_tool),
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Interactive options (Style, Ratio, Duration, etc.)
            ..._buildDynamicOptions(_tool),

            const SizedBox(height: 32),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  final prompt = _promptController.text.trim();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF7B4FCE),
                      content: Text(
                        prompt.isEmpty
                            ? 'Generating $_tool (mock)...'
                            : 'Generating: "$prompt"...',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'Generate $_tool',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _hintFor(String t) {
    switch (t) {
      case 'Video':
        return 'Describe your video scene...';
      case 'Sound':
        return 'Describe the sound or ambience...';
      case 'Music':
        return 'Describe the music mood, genre...';
      case 'Text':
        return 'What text do you want to generate?';
      case 'Avatar':
        return 'Describe your avatar...';
      case 'Upscale':
        return 'Describe image details to upscale...';
      case 'Remove BG':
        return 'Describe image to remove background...';
      default:
        return 'Describe what you want to create...';
    }
  }

  List<Widget> _buildDynamicOptions(String t) {
    if (t == 'Image' || t == 'Avatar') {
      return [
        _label('Style'),
        _chips(['Cinematic', 'Realistic', 'Anime', 'Noir'], isOption1: true),
        const SizedBox(height: 20),
        _label('Aspect ratio'),
        _chips(['1:1', '16:9', '9:16'], isOption1: false),
      ];
    }
    if (t == 'Video') {
      return [
        _label('Duration'),
        _chips(['5s', '10s', '15s'], isOption1: true),
        const SizedBox(height: 20),
        _label('Aspect ratio'),
        _chips(['16:9', '9:16', '1:1'], isOption1: false),
      ];
    }
    if (t == 'Music' || t == 'Sound') {
      return [
        _label('Genre'),
        _chips(['Ambient', 'Cinematic', 'Lo-fi', 'Epic'], isOption1: true),
        const SizedBox(height: 20),
        _label('Length'),
        _chips(['30s', '1 min', '2 min'], isOption1: false),
      ];
    }
    if (t == 'Text') {
      return [
        _label('Tone'),
        _chips(['Formal', 'Casual', 'Creative', 'Marketing'], isOption1: true),
      ];
    }
    if (t == 'Upscale') {
      return [
        _label('Scale'),
        _chips(['2x', '4x', '8x'], isOption1: true),
      ];
    }
    if (t == 'Remove BG') {
      return [
        _label('Output'),
        _chips(['Transparent', 'White', 'Black'], isOption1: true),
      ];
    }
    return [];
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _chips(List<String> items, {required bool isOption1}) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.asMap().entries.map((entry) {
        final int index = entry.key;
        final String label = entry.value;
        final bool isSelected = isOption1
            ? _selectedOption1 == index
            : _selectedOption2 == index;

        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) {
              setState(() {
                if (isOption1) {
                  _selectedOption1 = index;
                } else {
                  _selectedOption2 = index;
                }
              });
            }
          },
          selectedColor: const Color(0xFF7B4FCE),
          backgroundColor: const Color(0xFF181228),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
