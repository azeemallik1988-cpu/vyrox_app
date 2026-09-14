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
      color: VyroxColors.bg,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _Hero(onVip: () => context.push('/vip')),
            const SizedBox(height: 16),
            _ToolBoard(
              tools: _tools,
              onTool: (type) => context.push('/tool/${type.param}'),
              onMore: () => context.go('/create'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _GradientAction(
                    label: 'New Project',
                    icon: Icons.add,
                    onTap: () => context.go('/create'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _DarkAction(
                    label: 'Resources',
                    icon: Icons.auto_awesome,
                    onTap: () => context.go('/explore'),
                  ),
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
              height: 92,
              child: recent.isEmpty
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 92,
                          child: GradientPlaceholder(seed: 40 + index * 37),
                        );
                      },
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recent.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final item = recent[index];
                        return SizedBox(
                          width: 92,
                          child: InkWell(
                            onTap: () =>
                                context.push('/creations/detail/${item.id}'),
                            borderRadius: BorderRadius.circular(16),
                            child: GradientPlaceholder(
                              seed: item.thumbnailSeed,
                            ),
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
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 210,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2A1850),
                    Color(0xFF090A0F),
                    Color(0xFF12324A),
                  ],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0xCC090A0F),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: InkWell(
                onTap: onVip,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8FF4A),
                    borderRadius: BorderRadius.circular(12),
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
              bottom: 18,
              child: Text(
                'VYROX AI STUDIO',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
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
            width: 42,
            height: 36,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                if (badge != null)
                  Positioned(
                    top: -6,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badge == 'Turbo'
                            ? const Color(0xFF3D7CFF)
                            : VyroxColors.accent,
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

class _GradientAction extends StatelessWidget {
  const _GradientAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        height: 86,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C5CFF), Color(0xFFD6FF4A)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkAction extends StatelessWidget {
  const _DarkAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        height: 86,
        decoration: BoxDecoration(
          color: VyroxColors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: VyroxColors.line),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
