import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/vyrox_theme.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Projects', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...MockData.projects.map(
            (p) => Card(
              color: VyroxColors.card,
              child: ListTile(
                leading: const Icon(Icons.movie_outlined, color: VyroxColors.accent),
                title: Text(p.title),
                subtitle: Text('${p.kind} · ${p.status}'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
