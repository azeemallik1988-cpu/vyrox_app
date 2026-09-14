import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/vyrox_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF2A1850),
                    child: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Creator', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        Text('Guest · sign in in Stage 3', style: TextStyle(color: Color(0xFFB9B9C6))),
                      ],
                    ),
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
                        Text('Plan · Free', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16)),
                        Text('Unlock Turbo and Avatar priority', style: TextStyle(color: Colors.black87)),
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
                color: VyroxColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: VyroxColors.line),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt, color: Color(0xFFB8FF4A)),
                  SizedBox(width: 10),
                  Expanded(child: Text('Credits', style: TextStyle(fontWeight: FontWeight.w700))),
                  Text('120', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _Tile(label: 'Appearance', onTap: () => _snack(context, 'Appearance')),
            _Tile(label: 'Notifications', onTap: () => _snack(context, 'Notifications')),
            _Tile(label: 'Help', onTap: () => _snack(context, 'Help')),
            _Tile(label: 'Privacy Policy', onTap: () => _snack(context, 'Privacy Policy')),
            _Tile(label: 'Terms', onTap: () => _snack(context, 'Terms')),
            _Tile(label: 'About', onTap: () => _snack(context, 'About VYROX AI Studio')),
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
