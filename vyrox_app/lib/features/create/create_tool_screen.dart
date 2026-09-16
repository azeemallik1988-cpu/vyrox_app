import 'package:flutter/material.dart';

class CreateToolScreen extends StatelessWidget {
  final CreationType? tool;
  const CreateToolScreen({super.key, this.tool});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> grid = const [
      {'icon': Icons.image, 'label': 'Image', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
      {'icon': Icons.videocam, 'label': 'Video', 'badge': 'Turbo', 'c': Color(0xFF3B82F6)},
      {'icon': Icons.audiotrack, 'label': 'Sound', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
      {'icon': Icons.menu, 'label': 'Text', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
      {'icon': Icons.zoom_in, 'label': 'Upscale', 'badge': 'Turbo', 'c': Color(0xFF3B82F6)},
      {'icon': Icons.hide_image, 'label': 'Remove BG', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
      {'icon': Icons.face, 'label': 'Avatar', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
      {'icon': Icons.music_note, 'label': 'Music', 'badge': 'Turbo', 'c': Color(0xFF3B82F6)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 8 tools grid at top (this is what was missing!)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1,
              ),
              itemCount: grid.length,
              itemBuilder: (context, i) {
                final t = grid[i];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF181228),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(t['icon'] as IconData, size: 24, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(t['label'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                  ]),
                );
              },
            ),
            const SizedBox(height: 24),

            // Prompt / Style / Generate (your existing design)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF181228),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Describe what you want to create...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0D0A14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      hintText: 'A cinematic portrait in neon light...',
                      hintStyle: const TextStyle(color: Colors.white38),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('Style', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Cinematic', 'Realistic', 'Anime', 'Noir'].map((s) {
                return ChoiceChip(
                  label: Text(s),
                  selected: s == 'Cinematic',
                  onSelected: (_) {},
                  selectedColor: const Color(0xFF7B4FCE),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color(0xFF181228),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            const Text('Aspect ratio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['1:1', '16:9', '9:16'].map((r) {
                return ChoiceChip(
                  label: Text(r),
                  selected: r == '1:1',
                  onSelected: (_) {},
                  selectedColor: const Color(0xFF7B4FCE),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color(0xFF181228),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Standard — Turbo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: Switch(
                value: true,
                onChanged: (_) {},
                activeColor: const Color(0xFFC8F560),
              ),
            ),
            const SizedBox(height: 20),
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
                    const SnackBar(content: Text('Mock generation complete — Stage 4 engine next'), duration: Duration(seconds: 2)),
                  );
                },
                child: const Text('Generate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
