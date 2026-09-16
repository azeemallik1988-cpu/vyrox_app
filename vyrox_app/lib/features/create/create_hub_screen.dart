import 'package:flutter/material.dart';
import 'create_tool_screen.dart';

class CreateHubScreen extends StatelessWidget {
  const CreateHubScreen({super.key});

  final List<Map<String, dynamic>> tools = const [
    {'icon': Icons.image, 'label': 'Image'},
    {'icon': Icons.videocam, 'label': 'Video'},
    {'icon': Icons.audiotrack, 'label': 'Sound'},
    {'icon': Icons.menu, 'label': 'Text'},
    {'icon': Icons.zoom_in, 'label': 'Upscale'},
    {'icon': Icons.hide_image, 'label': 'Remove BG'},
    {'icon': Icons.face, 'label': 'Avatar'},
    {'icon': Icons.music_note, 'label': 'Music'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pick a tool to start creating', style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.1,
                ),
                itemCount: tools.length,
                itemBuilder: (context, i) {
                  final t = tools[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CreateToolScreen(tool: t['label'] as String),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(t['icon'] as IconData, size: 34, color: Colors.white),
                          const SizedBox(height: 10),
                          Text(t['label'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
