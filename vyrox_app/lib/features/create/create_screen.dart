import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/creation.dart';
import '../../core/theme/vyrox_theme.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  static const tools = CreationType.values;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: VyroxColors.bg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            const Text(
              'Create',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pick a tool. Mock engines for now — real ones next.',
              style: TextStyle(color: Color(0xFFB9B9C6)),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
              decoration: BoxDecoration(
                color: VyroxColors.card,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: VyroxColors.line),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
                childAspectRatio: 0.92,
                children: [
                  for (final tool in tools)
                    _Cell(
                      icon: tool.icon,
                      label: tool.label,
                      badge: tool == CreationType.video
                          ? 'Turbo'
                          : tool == CreationType.image
                              ? 'Free'
                              : null,
                      onTap: () => context.push('/tool/${tool.param}'),
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

class _Cell extends StatelessWidget {
  const _Cell({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 42,
            height: 36,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(child: Icon(icon, color: Colors.white, size: 28)),
                if (badge != null)
                  Positioned(
                    top: -6,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badge == 'Turbo' ? const Color(0xFF3D7CFF) : VyroxColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              height: 1.15,
              color: Color(0xFFB9B9C6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
