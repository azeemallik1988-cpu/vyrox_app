import 'package:flutter/material.dart';
import '../create/create_screen.dart';
import '../creations/creations_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> tools = const [
    {'icon': Icons.image, 'label': 'Image', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
    {'icon': Icons.videocam, 'label': 'Video', 'badge': 'Turbo', 'c': Color(0xFF3B82F6)},
    {'icon': Icons.audiotrack, 'label': 'Sound', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
    {'icon': Icons.menu, 'label': 'Text', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
    {'icon': Icons.zoom_in, 'label': 'Upscale', 'badge': 'Turbo', 'c': Color(0xFF3B82F6)},
    {'icon': Icons.hide_image, 'label': 'Remove BG', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
    {'icon': Icons.face, 'label': 'Avatar', 'badge': 'Free', 'c': Color(0xFF7B4FCE)},
    {'icon': Icons.music_note, 'label': 'Music', 'badge': 'Turbo', 'c': Color(0xFF3B82F6)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('VYROX AI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -4, height: 1)),
              const Text('STUDIO', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFC8F560), letterSpacing: -4, height: 1)),
              const SizedBox(height: 24),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
                ),
                itemCount: tools.length,
                itemBuilder: (context, i) {
                  final t = tools[i];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Icon(t['icon'] as IconData, size: 28, color: Colors.white),
                              Positioned(
                                top: 2, right: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: t['c'] as Color,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    t['badge'] as String,
                                    style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            t['label'] as String,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/explore'),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF5D3A9B), Color(0xFF2A1545)]),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Discover', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 4),
                            Text('Community prompts & trending tools', style: TextStyle(fontSize: 13, color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward, color: Color(0xFFC8F560)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F0C17),
        selectedItemColor: const Color(0xFF7B4FCE),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (i) {
            if (i == 1) {
            // Create tab — opens Create screen when you build it
          }
          } else if (i == 2) {
            Navigator.pushNamed(context, '/explore');
          } else if (i == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CreationsScreen()));
          } else if (i == 4) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Creations'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
