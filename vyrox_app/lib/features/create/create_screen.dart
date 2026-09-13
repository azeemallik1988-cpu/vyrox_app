import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/vyrox_theme.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: MockData.tools
            .map(
              (t) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VyroxColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: VyroxColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: VyroxColors.accent),
                    const Spacer(),
                    Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const Text('Mock engine · free route', style: TextStyle(color: VyroxColors.muted)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
