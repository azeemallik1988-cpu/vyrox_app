import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VyroxApp());
}

class VyroxApp extends StatelessWidget {
  const VyroxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VYROX AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B6CFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF090A0F),
      ),
      home: const VyroxHomeScreen(),
    );
  }
}

class VyroxHomeScreen extends StatefulWidget {
  const VyroxHomeScreen({super.key});

  @override
  State<VyroxHomeScreen> createState() => _VyroxHomeScreenState();
}

class _VyroxHomeScreenState extends State<VyroxHomeScreen> {
  int selectedIndex = 0;

  static const pages = <Widget>[
    HomePage(),
    SimplePage(title: 'CREATE', icon: Icons.auto_awesome),
    SimplePage(title: 'PROJECTS', icon: Icons.video_library_outlined),
    SimplePage(title: 'ASSETS', icon: Icons.collections_outlined),
    SimplePage(title: 'PROFILE', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: const Color(0xFF11131A),
        indicatorColor: const Color(0x409B6CFF),
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_outlined),
            selectedIcon: Icon(Icons.collections),
            label: 'Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VYROX AI STUDIO',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 1.6,
                color: Color(0xFF9B6CFF),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Create with AI',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Generate video, images, and assets from one studio.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xA6FFFFFF),
              ),
            ),
            SizedBox(height: 28),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _FeatureCard(
                    icon: Icons.auto_awesome,
                    title: 'Generate',
                    subtitle: 'Text to video',
                  ),
                  _FeatureCard(
                    icon: Icons.image_outlined,
                    title: 'Images',
                    subtitle: 'AI stills',
                  ),
                  _FeatureCard(
                    icon: Icons.movie_outlined,
                    title: 'Projects',
                    subtitle: 'Your timeline',
                  ),
                  _FeatureCard(
                    icon: Icons.folder_outlined,
                    title: 'Assets',
                    subtitle: 'Library',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  const SimplePage({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: const Color(0xFF9B6CFF)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11131A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A2D3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF9B6CFF), size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0x8CFFFFFF),
            ),
          ),
        ],
      ),
    );
  }
}
