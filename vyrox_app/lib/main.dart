import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/config/vyrox_config.dart';
import 'core/state/creations_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (VyroxConfig.isConfigured) {
    await Supabase.initialize(
      url: VyroxConfig.supabaseUrl,
      anonKey: VyroxConfig.supabaseAnonKey,
    );
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const VyroxApp(),
    ),
  );
}
