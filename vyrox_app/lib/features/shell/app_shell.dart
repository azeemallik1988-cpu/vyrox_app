import 'package:flutter/material.dart';

import '../../core/theme/vyrox_theme.dart';
import '../assets/assets_screen.dart';
import '../create/create_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../projects/projects_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  static const pages = <Widget>[
    HomeScreen(),
    CreateScreen(),
    ProjectsScreen(),
    AssetsScreen(),
    ProfileScreen(),
  ];

  static const titles = ['Home', 'Create', 'Projects', 'Assets', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      drawer: wide
          ? null
          : Drawer(
              backgroundColor: VyroxColors.surface,
              child: _SideMenu(
                index: index,
                onSelect: (i) {
                  setState(() => index = i);
                  Navigator.pop(context);
                },
              ),
            ),
      body: Row(
        children: [
          if (wide)
            SizedBox(
              width: 240,
              child: _SideMenu(
                index: index,
                onSelect: (i) => setState(() => index = i),
              ),
            ),
          Expanded(child: pages[index]),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) => setState(() => index = i),
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

class _SideMenu extends StatelessWidget {
  const _SideMenu({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Create', 'Projects', 'Assets', 'Profile'];
    const icons = [
      Icons.home_outlined,
      Icons.auto_awesome_outlined,
      Icons.video_library_outlined,
      Icons.collections_outlined,
      Icons.person_outline,
    ];

    return ColoredBox(
      color: VyroxColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'VYROX AI STUDIO',
                style: TextStyle(
                  color: VyroxColors.accent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            for (var i = 0; i < labels.length; i++)
              ListTile(
                selected: index == i,
                selectedTileColor: const Color(0x409B6CFF),
                leading: Icon(icons[i], color: VyroxColors.accent),
                title: Text(labels[i]),
                onTap: () => onSelect(i),
              ),
          ],
        ),
      ),
    );
  }
}
