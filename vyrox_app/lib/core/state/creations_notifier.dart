import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/creation.dart';

const _prefsKey = 'vyrox_creations_v1';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences override missing');
});

final creationsProvider =
    StateNotifierProvider<CreationsNotifier, List<Creation>>((ref) {
  return CreationsNotifier(ref.watch(sharedPreferencesProvider));
});

class CreationsNotifier extends StateNotifier<List<Creation>> {
  CreationsNotifier(this._prefs) : super(const []) {
    state = _load();
  }

  final SharedPreferences _prefs;

  List<Creation> _load() {
    final raw = _prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return const [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Creation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _save() async {
    final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
    await _prefs.setString(_prefsKey, encoded);
  }

  void add(Creation creation) {
    state = [creation, ...state];
    _save();
  }

  void markDone(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(status: CreationStatus.done) else item,
    ];
    _save();
  }

  void remove(String id) {
    state = state.where((item) => item.id != id).toList();
    _save();
  }
}
