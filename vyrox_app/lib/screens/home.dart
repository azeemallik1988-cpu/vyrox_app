import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'create.dart';
import 'creations.dart';
import 'vip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    final CreationsStore store = VyroxScope.of(context);
    final List<Creation> recent = store.items.take(10).toList(growable: false);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const _HeroBanner(),
        const _ToolPanel(),
        const SizedBox(height: VyroxSpace.lg),
        const _ActionRow(),
        const VyroxSectionLabel('Recent creations'),
        if (recent.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
            child: Text(
              'Your latest work will appear here.',
              style: type.bodyMuted,
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
              itemCount: recent.length,
              separatorBuilder: (_, __) => const SizedBox(width: VyroxSpace.md),
              itemBuilder: (BuildContext context, int i) => SizedBox(
                width: 120,
                child: CreationThumb(creation: recent[i]),
              ),
            ),
          ),
        const VyroxSectionLabel('VYROX VIP'),
        const VipPromoCard(),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Hero banner
// ---------------------------------------------------------------------------

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    final double topInset = MediaQuery.of(context).padding.top;
    final VyroxShellScope? scope = VyroxShellScope.maybeOf(context);

    return SizedBox(
      height: 320 + topInset,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF1B1140),
                  Color(0xFF3B2A6E),
                  Color(0xFF0B1B3A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const Positioned(
            left: -70,
            top: 30,
            child: _Glow(size: 240, color: Color(0x669B6CFF)),
          ),
          const Positioned(
            right: -60,
            bottom: 40,
            child: _Glow(size: 280, color: Color(0x4400C2FF)),
          ),
          const Positioned(
            right: 90,
            top: 120,
            child: _Glow(size: 120, color: Color(0x55B9FF5C)),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 130,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0x00000000), VyroxColors.background],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                VyroxSpace.xl,
                topInset + VyroxSpace.md,
                VyroxSpace.lg,
                VyroxSpace.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _CrownBadge(onTap: () => openVip(context)),
                      const Spacer(),
                      Container(
                        width: 112,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(VyroxRadius.sm),
                          border: Border.all(color: Colors.white54),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const SeedThumb(
                          seed: 77,
                          icon: Icons.movie_outlined,
                          radius: 8,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Workspace panel',
                        onPressed: scope?.togglePanel,
                        icon: const Icon(
                          Icons.view_sidebar_outlined,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: VyroxSpace.md,
                        vertical: VyroxSpace.sm,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x66000000),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFF7FE9FF)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.auto_awesome,
                              size: 14, color: Color(0xFFB9FF5C)),
                          SizedBox(width: 6),
                          Text(
                            'AI  Replace the background with @image',
                            style: TextStyle(
                              color: Color(0xFFDFF9FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: VyroxSpace.lg),
                  Text(
                    'VYROX × Studio',
                    style: type.display.copyWith(
                      color: Colors.white,
                      fontSize: 38 * type.scale,
                    ),
                  ),
                  const SizedBox(height: VyroxSpace.xs),
                  Text(
                    'Image · Motion video · Voice · Text — all in one place',
                    style: type.bodyMuted.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[color, const Color(0x00000000)],
        ),
      ),
    );
  }
}

class _CrownBadge extends StatelessWidget {
  const _CrownBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VyroxRadius.sm),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFB9FF5C),
          borderRadius: BorderRadius.circular(VyroxRadius.sm),
        ),
        child: const Icon(
          Icons.workspace_premium,
          color: Color(0xFF1A1A1A),
          size: 24,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3x3 tool panel
// ---------------------------------------------------------------------------

class _ToolPanel extends StatelessWidget {
  const _ToolPanel();

  @override
  Widget build(BuildContext context) {
    final List<_HomeTool> tools = <_HomeTool>[
      _HomeTool(
        icon: CreationType.image.icon,
        label: 'Text to Image',
        badge: 'FLUX',
        onTap: () => openTool(context, CreationType.image),
      ),
      _HomeTool(
        icon: CreationType.video.icon,
        label: 'Image to Video',
        badge: 'Motion',
        onTap: () => openTool(context, CreationType.video),
      ),
      _HomeTool(
        icon: CreationType.text.icon,
        label: 'Script & Copy',
        onTap: () => openTool(context, CreationType.text),
      ),
      _HomeTool(
        icon: CreationType.avatar.icon,
        label: 'AI Avatar',
        badge: 'New',
        onTap: () => openTool(context, CreationType.avatar),
      ),
      _HomeTool(
        icon: CreationType.sound.icon,
        label: 'AI Voice',
        onTap: () => openTool(context, CreationType.sound),
      ),
      _HomeTool(
        icon: CreationType.upscale.icon,
        label: 'AI Ultra HD',
        badge: 'HD',
        onTap: () => openTool(context, CreationType.upscale),
      ),
      _HomeTool(
        icon: CreationType.removeBg.icon,
        label: 'Remove BG',
        onTap: () => openTool(context, CreationType.removeBg),
      ),
      _HomeTool(
        icon: CreationType.music.icon,
        label: 'AI Music',
        onTap: () => openTool(context, CreationType.music),
      ),
      _HomeTool(
        icon: Icons.grid_view_rounded,
        label: 'More',
        onTap: () => vyroxTab.value = 1,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.lg),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          VyroxSpace.md,
          VyroxSpace.xl,
          VyroxSpace.md,
          VyroxSpace.lg,
        ),
        decoration: BoxDecoration(
          color: VyroxColors.surface,
          borderRadius: BorderRadius.circular(VyroxRadius.xl),
          border: Border.all(color: VyroxColors.border),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: VyroxSpace.lg,
          childAspectRatio: 1.05,
          children: tools,
        ),
      ),
    );
  }
}

class _HomeTool extends StatelessWidget {
  const _HomeTool({
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
    final VyroxType type = VyroxType.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VyroxRadius.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: VyroxColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(VyroxRadius.md),
                  border: Border.all(color: VyroxColors.border),
                ),
                child: Icon(icon, color: VyroxColors.textPrimary, size: 26),
              ),
              if (badge != null)
                Positioned(
                  top: -8,
                  right: -16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          VyroxColors.accent,
                          Color(0xFF4FC3F7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: VyroxSpace.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: type.caption.copyWith(
              color: VyroxColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// New Project / Resources row
// ---------------------------------------------------------------------------

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.lg),
      child: SizedBox(
        height: 150,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Material(
                borderRadius: BorderRadius.circular(VyroxRadius.xl),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => openTool(context, CreationType.image),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFF5BA8FF),
                          VyroxColors.accent,
                          Color(0xFFB9FF5C),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(VyroxRadius.xl),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF111111),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: VyroxSpace.md),
                        Text(
                          'New Project',
                          style: type.heading.copyWith(
                            color: const Color(0xFF111111),
                            fontSize: 20 * type.scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: VyroxSpace.md),
            Expanded(
              child: VyroxCard(
                raised: true,
                onTap: () => vyroxTab.value = 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Color(0xFF111111)),
                    ),
                    const SizedBox(height: VyroxSpace.md),
                    Text('Resources', style: type.heading),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
