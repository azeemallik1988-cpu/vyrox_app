class VyroxConfig {
  static const supabaseUrl = 'https://YOUR-PROJECT.supabase.co';
  static const supabaseAnonKey = 'PASTE_PUBLISHABLE_OR_ANON_KEY';

  static bool get isConfigured =>
      supabaseUrl.startsWith('https://') &&
      !supabaseUrl.contains('YOUR-PROJECT') &&
      supabaseAnonKey != 'PASTE_PUBLISHABLE_OR_ANON_KEY' &&
      supabaseAnonKey.length > 20;
}
