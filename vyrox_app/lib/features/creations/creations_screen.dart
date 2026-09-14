import 'package:flutter/material.dart';

class CreationsScreen extends StatelessWidget {
  const CreationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Creations', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('All', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            const Text('No creations yet. Open Create and generate one.', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: const [
                ChoiceChip(label: Text('All'), selected: true),
                ChoiceChip(label: Text('Images'), selected: false),
                ChoiceChip(label: Text('Videos'), selected: false),
              ],
            ),
            const SizedBox(height: 30),
            const Center(child: Icon(Icons.auto_awesome, size: 60, color: Colors.white24)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F0C17),
        selectedItemColor: const Color(0xFF7B4FCE),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/');
          else if (i == 2) Navigator.pushNamed(context, '/explore');
          else if (i == 4) Navigator.pushNamed(context, '/profile');
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
