import 'package:flutter/material.dart';
import 'create_tool_screen.dart';
import 'typography_screen.dart';
import '../enhance/enhance_hub_screen.dart';

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
      
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FEATURED: Typography Mode
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TypographyScreen())),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7B4FCE), Color(0xFF2D1B4E)],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFFC8F560), shape: BoxShape.circle),
                      child: const Icon(Icons.text_fields, color: Colors.black, size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Typography Mode', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('Posters · Logos · Quotes · T-shirts', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // FEATURED: Enhance
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnhanceHubScreen())),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF10B981), Color(0xFF0D5F44)],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFFFFFFFF), shape: BoxShape.circle),
                      child: const Icon(Icons.auto_fix_high, color: Color(0xFF10B981), size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Enhance', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('Face swap · Background · Passport', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Standard tools', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2,
                ),
                itemCount: tools.length,
                itemBuilder: (context, i) {
                  final t = tools[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateToolScreen(tool: t['label'] as String)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(t['icon'] as IconData, size: 30, color: Colors.white),
                          const SizedBox(height: 8),
                          Text(t['label'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
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
