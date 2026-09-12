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
        useMaterial3: true,
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
        indicatorColor: const Color(0xFF9B6CFF).withOpacity(0.25),
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
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const Row(
            children: [
              _LogoMark(),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VYROX AI',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'One Idea. Every Creation.',
                    style: TextStyle(
                      color: Color(0xFFAAAFC0),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 38),
          const Text(
            'WHAT DO YOU WANT\nTO CREATE?',
            style: TextStyle(
              fontSize: 31,
              height: 1.08,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Turn your idea into images, video, music, voice and complete creative projects.',
            style: TextStyle(
              color: Color(0xFFAAAFC0),
              fontSize: 15,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF151821),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF292D3A)),
            ),
            child: TextField(
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe anything...',
                hintStyle: const TextStyle(color: Color(0xFF777D90)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton.filled(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'UI test successful. Backend connection comes next.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'CREATE',
            style: TextStyle(
              color: Color(0xFFAAAFC0),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          const GridViewCards(),
        ],
      ),
    );
  }
}

class GridViewCards extends StatelessWidget {
  const GridViewCards({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      CreationItem('VIDEO', Icons.movie_creation_outlined),
      CreationItem('IMAGE', Icons.image_outlined),
      CreationItem('MUSIC', Icons.music_note_outlined),
      CreationItem('VOICE', Icons.mic_none),
      CreationItem('SOUND FX', Icons.graphic_eq),
      CreationItem('AUTO CREATE', Icons.auto_awesome),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${item.label} selected')),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF191C27),
                  Color(0xFF12141C),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF292D3A)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.icon,
                    color: const Color(0xFFB99AFF),
                    size: 29,
                  ),
                  const Spacer(),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CreationItem {
  final String label;
  final IconData icon;

  const CreationItem(this.label, this.icon);
}

class SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;

  const SimplePage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 58,
              color: const Color(0xFFB99AFF),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Feature development in progress',
              style: TextStyle(color: Color(0xFFAAAFC0)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF9B6CFF),
            Color(0xFF4DC6FF),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
      ),
    );
  }
}
