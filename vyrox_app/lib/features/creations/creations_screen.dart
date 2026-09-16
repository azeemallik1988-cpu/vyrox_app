import 'package:flutter/material.dart';
import '../../core/models/creation.dart';
import '../home/home_screen.dart';
import '../create/create_tool_screen.dart';
import '../profile/profile_screen.dart';

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('All', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -2)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFF181228), borderRadius: BorderRadius.circular(24)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
                Text('All', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Images', style: TextStyle(color: Colors.white60)),
                Text('Videos', style: TextStyle(color: Colors.white60)),
                Text('Audio', style: TextStyle(color: Colors.white60)),
              ]),
            ),
            const SizedBox(height: 24),
            const Center(child: Icon(Icons.auto_awesome, size: 60, color: Colors.white24)),
            const SizedBox(height: 12),
            const Text('No creations yet.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white54)),
            const SizedBox(height: 8),
            const Text('Open Create and generate one.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white38)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B4FCE), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), elevation: 0),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateToolScreen(tool: CreationType.image))),
                child: const Text('Go to Create', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          else if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateToolScreen(tool: CreationType.image)));
          else if (i == 2) Navigator.pushNamed(context, '/explore');
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
