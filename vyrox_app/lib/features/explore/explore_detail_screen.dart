import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/vyrox_theme.dart';
import '../../core/widgets/gradient_placeholder.dart';
import 'explore_data.dart';

class ExploreDetailScreen extends StatelessWidget {
  const ExploreDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final item = exploreItems.firstWhere((e) => e.id == id);

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: 220, child: GradientPlaceholder(seed: item.seed, borderRadius: 20)),
          const SizedBox(height: 16),
          Text(item.prompt, style: const TextStyle(color: VyroxColors.muted)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              context.push(
                '/tool/${item.type.param}?prompt=${Uri.encodeComponent(item.prompt)}',
              );
            },
            child: const Text('Use this prompt'),
          ),
        ],
      ),
    );
  }
}
