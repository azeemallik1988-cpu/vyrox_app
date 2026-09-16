import 'package:flutter/material.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

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
            const Text('Pick a tool. Mock engines for now — real ones in Stage 4.', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1),
              itemCount: tools.length,
              itemBuilder: (context, i) {
                final t = tools[i];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF181228),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Stack(alignment: Alignment.topRight, children: [
                      Icon(t['icon'] as IconData, size: 28, color: Colors.white),
                      Positioned(top: 2, right: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: t['c'] as Color, borderRadius: BorderRadius.circular(8)), child: Text(t['badge'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)))),
                    ]),
                    const SizedBox(height: 6),
                    Text(t['label'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ]),
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF181228), borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0D0A14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      hintText: 'Describe your image...',
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock Image Generated (Stage 4 engine next)'), duration: Duration(seconds: 2)));
                      },
                      child: const Text('Generate (Mock)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F0C17),
        selectedItemColor: const Color(0xFF7B4FCE),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          else if (i == 2) Navigator.pushNamed(context, '/explore');
          else if (i == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const CreationsScreen()));
          else if (i == 4) Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
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
