import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/profile/profile_screen.dart';

void main() => runApp(const VyroxApp());

class VyroxApp extends StatelessWidget {
  const VyroxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyrox AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      routes: {
        '/explore': (context) => const ExploreScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
