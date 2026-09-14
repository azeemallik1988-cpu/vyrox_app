import 'package:flutter/material.dart';

import '../core/theme/vyrox_theme.dart';
import 'router.dart';

class VyroxApp extends StatefulWidget {
  const VyroxApp({super.key});

  @override
  State<VyroxApp> createState() => _VyroxAppState();
}

class _VyroxAppState extends State<VyroxApp> {
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VYROX AI',
      debugShowCheckedModeBanner: false,
      theme: VyroxTheme.dark(),
      routerConfig: _router,
    );
  }
}
