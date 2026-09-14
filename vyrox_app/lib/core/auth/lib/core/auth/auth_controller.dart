import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/vyrox_config.dart';

class AuthController {
  static bool get enabled => VyroxConfig.isConfigured;

  static SupabaseClient get client => Supabase.instance.client;

  static User? get user => enabled ? client.auth.currentUser : null;

  static bool get signedIn => user != null;

  static Future<AuthResponse> signIn(String email, String password) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signUp(String email, String password) {
    return client.auth.signUp(email: email, password: password);
  }

  static Future<void> signOut() {
    return client.auth.signOut();
  }

  static Future<int> credits() async {
    if (!signedIn) return 120;
    final row = await client
        .from('profiles')
        .select('credits')
        .eq('id', user!.id)
        .maybeSingle();
    return (row?['credits'] as int?) ?? 120;
  }

  static Future<void> saveProject({
    required String title,
    required String kind,
  }) async {
    if (!signedIn) return;
    await client.from('projects').insert({
      'title': title,
      'kind': kind,
      'status': 'Generating',
    });
  }
}
