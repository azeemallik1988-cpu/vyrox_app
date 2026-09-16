import 'package:flutter/material.dart';
import '../../core/auth/auth_controller.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';
import '../create/create_hub_screen.dart';
import '../creations/creations_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _credits = 120;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final c = await AuthController.credits();
    if (mounted) {
      setState(() {
        _credits = c;
        _loading = false;
      });
    }
  }

  Future<void> _handleSignOut() async {
    await AuthController.signOut();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out from Vyrox AI')),
      );
      _loadProfileData();
    }
  }

  Future<void> _handleSignIn() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    if (result == true) {
      _loadProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignedIn = AuthController.signedIn;
    final userEmail = AuthController.user?.email ?? 'Guest User';
    final userName = userEmail.contains('@') ? userEmail.split('@')[0] : userEmail;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2D1B4E).withOpacity(0.5),
                      const Color(0xFF0D0A14).withOpacity(0.95),
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF4A2A7A),
                      child: Icon(
                        isSignedIn ? Icons.person : Icons.person_outline,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                isSignedIn ? 'Signed in' : 'Not signed in',
                                style: TextStyle(
                                  color: isSignedIn ? const Color(0xFF10B981) : Colors.orangeAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: isSignedIn ? _handleSignOut : _handleSignIn,
                                child: Text(
                                  isSignedIn ? 'Sign out' : 'Sign in →',
                                  style: TextStyle(
                                    color: isSignedIn ? const Color(0xFFA78BFA) : const Color(0xFFC8F560),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Upgrade Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7B4FCE), Color(0xFFC8F560)],
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plan · Free',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Unlock Turbo and Avatar priority',
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      child: const Text('Upgrade', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Credits Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF181228),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Color(0xFFC8F560), size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Credits',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Spacer(),
                    _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            '$_credits',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Menu Settings
              _MenuRow(title: 'Appearance', onTap: () {}),
              const SizedBox(height: 10),
              _MenuRow(title: 'Notifications', onTap: () {}),
              const SizedBox(height: 10),
              _MenuRow(title: 'Help', onTap: () {}),
              const SizedBox(height: 10),
              _MenuRow(title: 'Privacy Policy', onTap: () {}),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F0C17),
        selectedItemColor: const Color(0xFF7B4FCE),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        onTap: (i) {
          if (i == 0) Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          else if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateHubScreen()));
          else if (i == 2) Navigator.pushNamed(context, '/explore');
          else if (i == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const CreationsScreen()));
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

class _MenuRow extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const _MenuRow({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF181228),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
