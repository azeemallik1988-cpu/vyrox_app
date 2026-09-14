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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Creations', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final item in const ['All', 'Images', 'Videos', 'Sounds', 'Text'])
                  ChoiceChip(
                    label: Text(item),
                    selected: filter == item,
                    onSelected: (_) => setState(() => filter = item),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'No creations yet.\nOpen Create and generate one.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: VyroxColors.muted),
                      ),
                    )
                  : GridView.builder(
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return InkWell(
                          onTap: () => context.push('/creations/detail/${item.id}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: GradientPlaceholder(seed: item.thumbnailSeed)),
                              const SizedBox(height: 6),
                              Text(
                                item.prompt,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${item.type.label} · ${item.status.name}',
                                style: const TextStyle(color: VyroxColors.muted, fontSize: 12),
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
    );
  }
}
