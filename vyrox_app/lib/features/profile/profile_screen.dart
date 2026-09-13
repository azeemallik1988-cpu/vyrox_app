import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/vyrox_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              color: VyroxColors.card,
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Guest creator'),
                subtitle: Text('Sign in coming next'),
              ),
            ),
            Card(
              color: VyroxColors.card,
              child: ListTile(
                leading: Icon(Icons.bolt, color: VyroxColors.accent),
                title: Text('Credits'),
                trailing: Text('${MockData.credits}'),
              ),
            ),
            Card(
              color: VyroxColors.card,
              child: ListTile(
                title: Text('Settings'),
                subtitle: Text('Theme, engines, storage'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
