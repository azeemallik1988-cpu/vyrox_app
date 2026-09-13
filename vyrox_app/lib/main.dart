import 'package:flutter/material.dart';

import 'core/store.dart';
import 'core/theme.dart';
import 'shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final CreationsStore store = CreationsStore();
  await store.load();
  runApp(VyroxScope(store: store, child: const VyroxApp()));
}

class VyroxApp extends StatelessWidget {
  const VyroxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VYROX AI Studio',
      debugShowCheckedModeBanner: false,
      theme: VyroxTheme.dark(),
      home: const VyroxShell(),
    );
  }
}
