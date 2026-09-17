import 'package:shared_preferences/shared_preferences.dart';

class KeyStore {
  static const _segmindPref = 'segmind_api_key';
  static String segmind = '';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    segmind = prefs.getString(_segmindPref) ?? '';
  }

  static Future<void> saveSegmind(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final clean = key.trim();
    await prefs.setString(_segmindPref, clean);
    segmind = clean;
  }
}
