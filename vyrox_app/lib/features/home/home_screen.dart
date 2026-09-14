import 'package:flutter/material.dart';

class StudioHomeScreen extends StatelessWidget {
  const StudioHomeScreen({super.key});

  final List<Map<String, dynamic>> tools = const [
    {'icon': Icons.image, 'label': 'Image', 'badge': 'Free', 'color': Color(0xFF7B4FCE)},
    {'icon': Icons.videocam, 'label': 'Video', 'badge': 'Turbo', 'color': Color(0xFF3B82F6)},
    {'icon': Icons.audiotrack, 'label': 'Sound', 'badge': 'Free', 'color': Color(0xFF7B4FCE)},
    {'icon': Icons.menu, 'label': 'Text', 'badge': 'Free', 'color': Color(0xFF7B4FCE)},
    {'icon': Icons.zoom_in, 'label': 'Upscale', 'badge': 'Turbo', 'color': Color(0xFF3B82F6)},
    {'icon': Icons.hide_image, 'label': 'Remove BG', 'badge': 'Free', 'color': Color(0xFF7B4FCE)},
    {'icon': Icons.face, 'label': 'Avatar', 'badge': 'Free', 'color': Color(0xFF7B4FCE)},
    {'icon': Icons.music_note, 'label': 'Music', 'badge': 'Turbo', 'color': Color(0xFF3B82F6)},
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
              const Text(
                'VYROX AI',
                style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white,
                  letterSpacing: -4, height: 0.95,
                ),
              ),
              const Text(
                'STUDIO',
                style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold,
                  color: Color(0xFFC8F560), letterSpacing: -4, height: 0.95,
                ),
              ),
              const SizedBox(height: 24),
              
              // Tool Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1,
                ),
                itemCount: tools.length,
                itemBuilder: (context, i) {
                  final t = tools[i];
                  return Container(
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
                            Icon(t['icon'], size: 28, color: Colors.white),
                            Positioned(
                              top: 0, right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: t['color'],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  t['badge'],
                                  style: const TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t['label'],
                          style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),

              // Discover Card (Stage 2c)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF5D3A9B), Color(0xFF2A1545)],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover',
                            style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Community prompts & trending tools',
                            style: TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Color(0xFFC8F560)),
                      onPressed: () {
                        // Link to Explore screen
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: // Your existing 5-tab nav stays here; do not delete
          BottomNavigationBar(
            backgroundColor: const Color(0xFF0F0C17),
            selectedItemColor: const Color(0xFF7B4FCE),
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
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
