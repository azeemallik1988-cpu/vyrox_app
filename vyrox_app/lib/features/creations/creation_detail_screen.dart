import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/creations_notifier.dart';
import '../../core/theme/vyrox_theme.dart';
import '../../core/widgets/gradient_placeholder.dart';

class CreationDetailScreen extends ConsumerWidget {
  const CreationDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(creationsProvider);
    final matches = items.where((e) => e.id == id);
    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Creation removed')),
      );
    }
    final item = matches.first;

    return Scaffold(
      appBar: AppBar(title: Text(item.type.label)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: 240, child: GradientPlaceholder(seed: item.thumbnailSeed, borderRadius: 20)),
          const SizedBox(height: 16),
          Text(item.prompt, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(item.status.name, style: const TextStyle(color: VyroxColors.muted)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share is mocked in v1')),
              );
            },
            child: const Text('Share'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              ref.read(creationsProvider.notifier).remove(item.id);
              context.go('/creations');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
