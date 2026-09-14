import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_controller.dart';
import '../../core/theme/vyrox_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int credits = 120;

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    if (!AuthController.enabled) return;
    try {
      final value = await AuthController.credits();
      if (mounted) setState(() => credits = value);
    } catch (_) {}
  }

  Future<void> _openLogin() async {
    final ok = await context.push<bool>('/login');
    if (ok == true && mounted) {
      setState(() {});
      await _loadCredits();
    }
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthController.user;
    final signedIn = user != null;

    return ColoredBox(
      color: VyroxColors.bg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: VyroxColors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: VyroxColors.line),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF2A1850),
                    child: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signedIn ? (user.email ?? 'Creator') : 'Creator',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          signedIn ? 'Signed in' : 'Guest · sign in to save',
                          style: const TextStyle(color: Color(0xFFB9B9C6)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: signedIn
                        ? () async {
                            await AuthController.signOut();
                            if (mounted) {
                              setState(() => credits = 120);
                            }
                          }
                        : _openLogin,
                    child: Text(signedIn ? 'Sign out' : 'Sign in'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C5CFF), Color(0xFFD6FF4A)],
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
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Unlock Turbo and Avatar priority',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () => context.push('/vip'),
                    child: const Text('Upgrade'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Color(0xFF181228),   // or similar dark grey
                borderRadius: BorderRadius.circular(28)
                border: Border.all(color: VyroxColors.line),
                ,
                child: ...
               ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Color(0xFFB8FF4A)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Credits', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Text(
                    '$credits',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _Tile(label: 'Appearance', onTap: () => _snack('Appearance')),
            _Tile(label: 'Notifications', onTap: () => _snack('Notifications')),
            _Tile(label: 'Help', onTap: () => _snack('Help')),
            _Tile(label: 'Privacy Policy', onTap: () => _snack('Privacy Policy')),
            _Tile(label: 'Terms', onTap: () => _snack('Terms')),
            _Tile(label: 'About', onTap: () => _snack('About VYROX AI Studio')),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: VyroxColors.card,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
