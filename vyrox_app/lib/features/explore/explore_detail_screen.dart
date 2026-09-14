import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/creation.dart';
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
      backgroundColor: VyroxColors.bg,
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SizedBox(
            height: 240,
            child: GradientPlaceholder(seed: item.seed, borderRadius: 24),
          ),
          const SizedBox(height: 16),
          Text(
            item.type.label,
            style: const TextStyle(color: VyroxColors.accent, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(item.prompt, style: const TextStyle(color: Color(0xFFB9B9C6), height: 1.4)),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C5CFF), Color(0xFFD6FF4A)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.push(
                      '/tool/${item.type.param}?prompt=${Uri.encodeComponent(item.prompt)}',
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: const Center(
                    child: Text(
                      'Use this prompt',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        body: SingleChildScrollView(
                          child: Column( // ...    
                      ),... keep everything that is already there ...
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
