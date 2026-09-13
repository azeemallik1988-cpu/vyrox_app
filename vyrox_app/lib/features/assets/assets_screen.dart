import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/vyrox_theme.dart';

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Assets', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...MockData.assets.map(
            (a) => Card(
              color: VyroxColors.card,
              child: ListTile(
                leading: const Icon(Icons.folder_outlined, color: VyroxColors.accent),
                title: Text(a.name),
                subtitle: Text(a.type),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
