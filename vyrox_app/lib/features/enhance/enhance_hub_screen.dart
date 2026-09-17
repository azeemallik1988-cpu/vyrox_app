import 'package:flutter/material.dart';
import 'passport_photo_screen.dart';
import 'face_swap_screen.dart';
import 'outfit_swap_screen.dart';
import 'ai_transform_screen.dart';

class EnhanceHubScreen extends StatelessWidget {
  const EnhanceHubScreen({super.key});

  final List<Map<String, dynamic>> tools = const [
    {
      'icon': Icons.badge,
      'label': 'Passport Photo',
      'sub': 'ID · Visa · print-ready',
      'color': Color(0xFF10B981),
      'route': 'passport',
    },
    {
      'icon': Icons.face_retouching_natural,
      'label': 'Face Swap',
      'sub': 'Swap faces · needs free key',
      'color': Color(0xFFF59E0B),
      'route': 'faceswap',
    },
    {
      'icon': Icons.checkroom,
      'label': 'Change Outfit',
      'sub': 'Virtual try-on · needs free key',
      'color': Color(0xFF3B82F6),
      'route': 'outfit',
    },
    {
      'icon': Icons.wallpaper,
      'label': 'Change Background',
      'sub': 'AI scene · beta',
      'color': Color(0xFF7B4FCE),
      'route': 'background',
    },
    {
      'icon': Icons.zoom_in,
      'label': 'Upscale HD',
      'sub': 'Sharper · beta',
      'color': Color(0xFFA78BFA),
      'route': 'upscale',
    },
    {
      'icon': Icons.hide_image,
      'label': 'Remove BG',
      'sub': 'Clean cutout · beta',
      'color': Color(0xFFEC4899),
      'route': 'removebg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Enhance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF7B4FCE).withOpacity(0.9),
                      const Color(0xFF2D1B4E).withOpacity(0.9),
                    ],
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFFC8F560), size: 32),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Photo Enhance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Transform your photos with AI', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Choose a tool', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...tools.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        if (t['route'] == 'passport') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const PassportPhotoScreen()));
                        } else if (t['route'] == 'faceswap') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const FaceSwapScreen()));
                        } else if (t['route'] == 'outfit') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const OutfitSwapScreen()));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AITransformScreen(mode: t['route'] as String, title: t['label'] as String),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181228),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (t['color'] as Color).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t['label'] as String, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text(t['sub'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.white38),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
