import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/creation.dart';
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
        backgroundColor: VyroxColors.bg,
        appBar: AppBar(),
        body: const Center(child: Text('Creation removed')),
      );
    }
    final item = matches.first;

    return Scaffold(
      backgroundColor: VyroxColors.bg,
      appBar: AppBar(title: Text(item.type.label)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SizedBox(
            height: 260,
            child: GradientPlaceholder(seed: item.thumbnailSeed, borderRadius: 24),
          ),
          const SizedBox(height: 16),
          Text(item.prompt, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            item.status.name,
            style: const TextStyle(color: Color(0xFFB9B9C6)),
          ),
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
