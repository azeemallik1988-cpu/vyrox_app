import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/creation.dart';
import '../../core/state/creations_notifier.dart';
import '../../core/theme/vyrox_theme.dart';
import '../../core/widgets/gradient_placeholder.dart';

class CreationsScreen extends ConsumerStatefulWidget {
  const CreationsScreen({super.key});

  @override
  ConsumerState<CreationsScreen> createState() => _CreationsScreenState();
}

class _CreationsScreenState extends ConsumerState<CreationsScreen> {
  String filter = 'All';

  bool _match(Creation item) {
    switch (filter) {
      case 'Images':
        return item.type == CreationType.image ||
            item.type == CreationType.upscale ||
            item.type == CreationType.removeBg ||
            item.type == CreationType.avatar;
      case 'Videos':
        return item.type == CreationType.video;
      case 'Sounds':
        return item.type == CreationType.sound || item.type == CreationType.music;
      case 'Text':
        return item.type == CreationType.text;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(creationsProvider).where(_match).toList();

    return ColoredBox(
      color: VyroxColors.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Creations',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final item in const ['All', 'Images', 'Videos', 'Sounds', 'Text'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(item),
                          selected: filter == item,
                          onSelected: (_) => setState(() => filter = item),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome, color: VyroxColors.accent, size: 40),
                            const SizedBox(height: 12),
                            const Text(
                              'No creations yet',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Open Create and generate one.',
                              style: TextStyle(color: Color(0xFFB9B9C6)),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () => context.go('/create'),
                              child: const Text('Create'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        itemCount: items.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return InkWell(
                            onTap: () => context.push('/creations/detail/${item.id}'),
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GradientPlaceholder(
                                    seed: item.thumbnailSeed,
                                    borderRadius: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.prompt,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${item.type.label} · ${item.status.name}',
                                  style: const TextStyle(
                                    color: Color(0xFFB9B9C6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
