import 'package:flutter/material.dart';

enum CreationType {
  image,
  video,
  sound,
  text,
  upscale,
  removeBg,
  avatar,
  music,
}

enum CreationStatus { queued, generating, done, failed }

CreationType creationTypeFromParam(String raw) {
  switch (raw) {
    case 'image':
      return CreationType.image;
    case 'video':
      return CreationType.video;
    case 'sound':
      return CreationType.sound;
    case 'text':
      return CreationType.text;
    case 'upscale':
      return CreationType.upscale;
    case 'removeBg':
    case 'removebg':
      return CreationType.removeBg;
    case 'avatar':
      return CreationType.avatar;
    case 'music':
      return CreationType.music;
    default:
      return CreationType.image;
  }
}

extension CreationTypeX on CreationType {
  String get param => name;

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

  IconData get icon {
    switch (this) {
      case CreationType.image:
        return Icons.image_outlined;
      case CreationType.video:
        return Icons.movie_outlined;
      case CreationType.sound:
        return Icons.graphic_eq;
      case CreationType.text:
        return Icons.notes;
      case CreationType.upscale:
        return Icons.hd_outlined;
      case CreationType.removeBg:
        return Icons.layers_clear_outlined;
      case CreationType.avatar:
        return Icons.face_retouching_natural;
      case CreationType.music:
        return Icons.library_music_outlined;
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'prompt': prompt,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'thumbnailSeed': thumbnailSeed,
    };
  }

  factory Creation.fromJson(Map<String, dynamic> json) {
    return Creation(
      id: json['id'] as String,
      type: creationTypeFromParam(json['type'] as String),
      prompt: json['prompt'] as String,
      status: CreationStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      thumbnailSeed: json['thumbnailSeed'] as int,
    );
  }
}
