import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Which bottom tab is selected. Screens pushed above the shell can change it.
final ValueNotifier<int> vyroxTab = ValueNotifier<int>(0);

enum CreationType { image, video, sound, text, upscale, removeBg, avatar, music }

enum CreationStatus { queued, generating, done, failed }

extension CreationTypeX on CreationType {
  String get label {
    switch (this) {
      case CreationType.image:
        return 'Image';
      case CreationType.video:
        return 'Video';
      case CreationType.sound:
        return 'Sound';
      case CreationType.text:
        return 'Text';
      case CreationType.upscale:
        return 'Upscale';
      case CreationType.removeBg:
        return 'Remove BG';
      case CreationType.avatar:
        return 'Avatar';
      case CreationType.music:
        return 'Music';
    }
  }

  String get hint {
    switch (this) {
      case CreationType.image:
        return 'Text to image';
      case CreationType.video:
        return 'Cinematic clips';
      case CreationType.sound:
        return 'Voice & SFX';
      case CreationType.text:
        return 'Copy & scripts';
      case CreationType.upscale:
        return 'Enhance resolution';
      case CreationType.removeBg:
        return 'Cut out subjects';
      case CreationType.avatar:
        return 'AI portraits';
      case CreationType.music:
        return 'Tracks & loops';
    }
  }

  IconData get icon {
    switch (this) {
      case CreationType.image:
        return Icons.image_outlined;
      case CreationType.video:
        return Icons.movie_outlined;
      case CreationType.sound:
        return Icons.graphic_eq;
      case CreationType.text:
        return Icons.text_fields;
      case CreationType.upscale:
        return Icons.hd_outlined;
      case CreationType.removeBg:
        return Icons.content_cut;
      case CreationType.avatar:
        return Icons.face_retouching_natural;
      case CreationType.music:
        return Icons.music_note_outlined;
    }
  }

  /// Filter group used by Creations and Explore.
  String get group {
    switch (this) {
      case CreationType.video:
        return 'Videos';
      case CreationType.sound:
      case CreationType.music:
        return 'Sounds';
      case CreationType.text:
        return 'Text';
      case CreationType.image:
      case CreationType.upscale:
      case CreationType.removeBg:
      case CreationType.avatar:
        return 'Images';
    }
  }
}

class Creation {
  const Creation({
    required this.id,
    required this.type,
    required this.prompt,
    required this.status,
    required this.createdAt,
    required this.thumbnailSeed,
  });

  final String id;
  final CreationType type;
  final String prompt;
  final CreationStatus status;
  final DateTime createdAt;
  final int thumbnailSeed;

  Creation copyWith({CreationStatus? status}) {
    return Creation(
      id: id,
      type: type,
      prompt: prompt,
      status: status ?? this.status,
      createdAt: createdAt,
      thumbnailSeed: thumbnailSeed,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.name,
        'prompt': prompt,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'seed': thumbnailSeed,
      };

  factory Creation.fromJson(Map<String, dynamic> json) {
    CreationStatus status = CreationStatus.values.byName(json['status'] as String);
    // A job that was still running when the app closed is finished on restore.
    if (status == CreationStatus.generating || status == CreationStatus.queued) {
      status = CreationStatus.done;
    }
    return Creation(
      id: json['id'] as String,
      type: CreationType.values.byName(json['type'] as String),
      prompt: json['prompt'] as String,
      status: status,
      createdAt: DateTime.parse(json['createdAt'] as String),
      thumbnailSeed: json['seed'] as int,
    );
  }
}

class CreationsStore extends ChangeNotifier {
  static const String _key = 'vyrox_creations_v1';

  final List<Creation> _items = <Creation>[];

  List<Creation> get items => List<Creation>.unmodifiable(_items);

  int get credits => 120;

  Future<void> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString(_key);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        _items
          ..clear()
          ..addAll(list.map(
            (dynamic e) => Creation.fromJson(e as Map<String, dynamic>),
          ));
      }
    } catch (_) {
      // Corrupt or unavailable storage: start empty.
    }
    notifyListeners();
  }

  Future<void> _save() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key,
        jsonEncode(_items.map((Creation c) => c.toJson()).toList()),
      );
    } catch (_) {
      // Ignore storage failures; in-memory state is still correct.
    }
  }

  Creation? byId(String id) {
    for (final Creation c in _items) {
      if (c.id == id) {
        return c;
      }
    }
    return null;
  }

  void add(Creation creation) {
    _items.insert(0, creation);
    notifyListeners();
    _save();
  }

  void remove(String id) {
    _items.removeWhere((Creation c) => c.id == id);
    notifyListeners();
    _save();
  }

  /// Mock generation: adds a "generating" item that completes after a delay.
  Creation generate({
    required CreationType type,
    required String prompt,
    bool turbo = false,
  }) {
    final DateTime now = DateTime.now();
    final Creation creation = Creation(
      id: now.microsecondsSinceEpoch.toString(),
      type: type,
      prompt: prompt,
      status: CreationStatus.generating,
      createdAt: now,
      thumbnailSeed: now.millisecondsSinceEpoch % 100000,
    );
    add(creation);
    Timer(Duration(seconds: turbo ? 1 : 3), () => _complete(creation.id));
    return creation;
  }

  void _complete(String id) {
    final int index = _items.indexWhere((Creation c) => c.id == id);
    if (index < 0) {
      return;
    }
    _items[index] = _items[index].copyWith(status: CreationStatus.done);
    notifyListeners();
    _save();
  }
}

class VyroxScope extends InheritedNotifier<CreationsStore> {
  const VyroxScope({
    super.key,
    required CreationsStore store,
    required super.child,
  }) : super(notifier: store);

  static CreationsStore of(BuildContext context) {
    final VyroxScope? scope =
        context.dependOnInheritedWidgetOfExactType<VyroxScope>();
    assert(scope != null, 'VyroxScope not found above this widget');
    return scope!.notifier!;
  }
}
