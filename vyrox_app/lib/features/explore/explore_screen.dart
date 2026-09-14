import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/vyrox_theme.dart';
import '../../core/widgets/gradient_placeholder.dart';
import 'explore_data.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String filter = 'All';
  static const filters = ['All', 'Image', 'Video', 'Sound', 'Text', 'Avatar', 'Music'];

  @override
  Widget build(BuildContext context) {
    final items = exploreItems
        .where((e) => filter == 'All' || e.category == filter)
        .toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Explore', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final item in filters)
                ChoiceChip(
                  label: Text(item),
                  selected: filter == item,
                  onSelected: (_) => setState(() => filter = item),
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => context.push('/explore/detail/${item.id}'),
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  height: 120,
                  decoration: BoxDecoration(
                    color: VyroxColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: VyroxColors.line),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: GradientPlaceholder(seed: item.seed, borderRadius: 18),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(
                                item.prompt,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: VyroxColors.muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
