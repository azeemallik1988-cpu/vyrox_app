import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/creation.dart';
import '../../core/state/creations_notifier.dart';
import '../../core/theme/vyrox_theme.dart';
import '../../core/widgets/gradient_placeholder.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _tools = <CreationType>[
    CreationType.image,
    CreationType.video,
    CreationType.sound,
    CreationType.text,
    CreationType.upscale,
    CreationType.removeBg,
    CreationType.avatar,
    CreationType.music,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(creationsProvider).take(8).toList();

    return ColoredBox(
      color: const Color(0xFF07080C),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
          children: [
            _Hero(onVip: () => context.push('/vip')),
            const SizedBox(height: 14),
            _ToolBoard(
              tools: _tools,
              onTool: (type) => context.push('/tool/${type.param}'),
              onMore: () => context.go('/create'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _NewProject(onTap: () => context.go('/create')),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _Resources(onTap: () => context.go('/explore')),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Recent',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recent.isEmpty ? 4 : recent.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  if (recent.isEmpty) {
                    return SizedBox(
                      width: 96,
                      child: GradientPlaceholder(seed: 40 + index * 37),
                    );
                  }
                  final item = recent[index];
                  return SizedBox(
                    width: 96,
                    child: InkWell(
                      onTap: () => context.push('/creations/detail/${item.id}'),
                      borderRadius: BorderRadius.circular(18),
                      child: GradientPlaceholder(seed: item.thumbnailSeed),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onVip});

  final VoidCallback onVip;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 188,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3A1D73),
                    Color(0xFF0B0D14),
                    Color(0xFF06283A),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -40,
              right: -20,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x668B5CFF),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: 40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x3326C9FF),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xE607080C)],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: InkWell(
                onTap: onVip,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8FF4A),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66C8FF4A),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                'VYROX AI\nSTUDIO',
                style: TextStyle(
                  fontSize: 34,
                  height: 0.95,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolBoard extends StatelessWidget {
  const _ToolBoard({
    required this.tools,
    required this.onTool,
    required this.onMore,
  });

  final List<CreationType> tools;
  final ValueChanged<CreationType> onTool;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 6),
      decoration: BoxDecoration(
        color: const Color(0xFF12141C),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF262A38)),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 2,
        childAspectRatio: 1.02,
        children: [
          for (final tool in tools)
            _ToolCell(
              icon: tool.icon,
              label: tool.label,
              badge: tool == CreationType.video
                  ? 'Turbo'
                  : tool == CreationType.image
                      ? 'Free'
                      : null,
              onTap: () => onTool(tool),
            ),
          _ToolCell(
            icon: Icons.apps,
            label: 'More',
            onTap: onMore,
          ),
        ],
      ),
    );
  }
}

class _ToolCell extends StatelessWidget {
  const _ToolCell({
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
            width: 46,
            height: 34,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(child: Icon(icon, color: Colors.white, size: 26)),
                if (badge != null)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badge == 'Turbo'
                            ? const Color(0xFF3D7CFF)
                            : const Color(0xFF9B6CFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              height: 1.1,
              color: Color(0xFFB7B7C5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewProject extends StatelessWidget {
  const _NewProject({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        height: 78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF7A5CFF), Color(0xFFD8FF57)],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: Colors.black, size: 26),
            SizedBox(height: 4),
            Text(
              'New Project',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Resources extends StatelessWidget {
  const _Resources({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        height: 78,
        decoration: BoxDecoration(
          color: const Color(0xFF12141C),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF262A38)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white),
            SizedBox(height: 4),
            Text(
              'Resources',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
