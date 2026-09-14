import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/creation.dart';
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

    return ColoredBox(
      color: VyroxColors.bg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            const Text(
              'Explore',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Community mock feed. Use any prompt in Create.',
              style: TextStyle(color: Color(0xFFB9B9C6)),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = filters[index];
                  final selected = filter == item;
                  return ChoiceChip(
                    label: Text(item),
                    selected: selected,
                    onSelected: (_) => setState(() => filter = item),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => context.push('/explore/detail/${item.id}'),
                  borderRadius: BorderRadius.circular(22),
                  child: Ink(
                    height: 118,
                    decoration: BoxDecoration(
                      color: VyroxColors.card,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: VyroxColors.line),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 118,
                          child: GradientPlaceholder(seed: item.seed, borderRadius: 22),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.prompt,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Color(0xFFB9B9C6), height: 1.25),
                                ),
                                const Spacer(),
                                Text(
                                  item.type.label,
                                  style: const TextStyle(
                                    color: VyroxColors.accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
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
      ),
    );
  }
}
