import 'package:flutter/material.dart';

import 'core/theme/vyrox_theme.dart';
import 'features/shell/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VyroxApp());
}

class VyroxApp extends StatelessWidget {
  const VyroxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VYROX AI',
      debugShowCheckedModeBanner: false,
      theme: VyroxTheme.dark(),
      home: const AppShell(),
    );
  }
}
