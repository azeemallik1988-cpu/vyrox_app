class VyroxConfig {
  static const supabaseUrl = 'https://jsfualdvkkimpogrgaub.supabase.co';
  static const supabaseAnonKey = 'sb_publishable_ksqC6ZVt-LKBXMk8Wys7fg_xSmwuNId';

  static bool get isConfigured =>
      supabaseUrl.startsWith('https://') &&
      !supabaseUrl.contains('YOUR-PROJECT') &&
      supabaseAnonKey != 'PASTE_PUBLISHABLE_OR_ANON_KEY' &&
      supabaseAnonKey.length > 20;
}
