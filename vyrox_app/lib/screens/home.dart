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
    final List<Creation> recent = store.items.take(8).toList(growable: false);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(
          title: 'VYROX AI',
          subtitle: 'Your AI creative studio',
          showLogo: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: Container(
            padding: const EdgeInsets.all(VyroxSpace.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[VyroxColors.accentDeep, VyroxColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(VyroxRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome back',
                  style: type.bodyMuted.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: VyroxSpace.xs),
                Text(
                  'What will you create today?',
                  style: type.display.copyWith(color: Colors.white),
                ),
                const SizedBox(height: VyroxSpace.lg),
                FilledButton.icon(
                  onPressed: () => openTool(context, CreationType.image),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: VyroxColors.accentDeep,
                  ),
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Start creating'),
                ),
              ],
            ),
          ),
        ),
        const VyroxSectionLabel('Tools'),
        const ToolGrid(
          tools: <CreationType>[
            CreationType.image,
            CreationType.video,
            CreationType.sound,
            CreationType.text,
          ],
        ),
        const VyroxSectionLabel('VYROX VIP'),
        const VipPromoCard(),
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
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
              itemCount: recent.length,
              separatorBuilder: (_, __) => const SizedBox(width: VyroxSpace.md),
              itemBuilder: (BuildContext context, int i) => SizedBox(
                width: 132,
                child: CreationThumb(creation: recent[i]),
              ),
            ),
          ),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}
