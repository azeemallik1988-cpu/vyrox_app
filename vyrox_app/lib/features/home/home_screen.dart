import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/vyrox_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'VYROX AI STUDIO',
            style: TextStyle(
              color: VyroxColors.accent,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create with AI',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate video, images, and assets from one studio.',
            style: TextStyle(color: VyroxColors.muted),
          ),
          const SizedBox(height: 24),
          const Text('Quick actions', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockData.tools
                .map((t) => Chip(
                      label: Text(t),
                      backgroundColor: VyroxColors.card,
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text('Recent projects', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...MockData.projects.map(
            (p) => Card(
              color: VyroxColors.card,
              child: ListTile(
                title: Text(p.title),
                subtitle: Text('${p.kind} · ${p.status}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
