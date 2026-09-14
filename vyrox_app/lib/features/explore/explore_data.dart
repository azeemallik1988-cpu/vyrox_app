import '../../core/models/creation.dart';

class ExploreItem {
  const ExploreItem({
    required this.id,
    required this.title,
    required this.prompt,
    required this.type,
    required this.seed,
    required this.category,
  });

  final String id;
  final String title;
  final String prompt;
  final CreationType type;
  final int seed;
  final String category;
}

const exploreItems = <ExploreItem>[
  ExploreItem(id: 'e1', title: 'Neon alley', prompt: 'Rainy neon alley, cinematic', type: CreationType.image, seed: 11, category: 'Image'),
  ExploreItem(id: 'e2', title: 'Trailer cut', prompt: 'Epic trailer camera push-in', type: CreationType.video, seed: 22, category: 'Video'),
  ExploreItem(id: 'e3', title: 'Low drone', prompt: 'Dark ambient drone in D minor', type: CreationType.sound, seed: 33, category: 'Sound'),
  ExploreItem(id: 'e4', title: 'Hook copy', prompt: 'Write a 12-word product hook', type: CreationType.text, seed: 44, category: 'Text'),
  ExploreItem(id: 'e5', title: 'Portrait upscale', prompt: 'Upscale studio portrait', type: CreationType.upscale, seed: 55, category: 'Image'),
  ExploreItem(id: 'e6', title: 'Clean subject', prompt: 'Remove background from product', type: CreationType.removeBg, seed: 66, category: 'Image'),
  ExploreItem(id: 'e7', title: 'Creator face', prompt: 'Stylized avatar, short hair', type: CreationType.avatar, seed: 77, category: 'Avatar'),
  ExploreItem(id: 'e8', title: 'Night beat', prompt: '80s synthwave music loop', type: CreationType.music, seed: 88, category: 'Music'),
  ExploreItem(id: 'e9', title: 'Desert ship', prompt: 'Abandoned ship in a gold desert', type: CreationType.image, seed: 99, category: 'Image'),
  ExploreItem(id: 'e10', title: 'Macro drop', prompt: 'Macro water drop slow-mo', type: CreationType.video, seed: 111, category: 'Video'),
  ExploreItem(id: 'e11', title: 'UI whoosh', prompt: 'Soft whoosh for app transitions', type: CreationType.sound, seed: 122, category: 'Sound'),
  ExploreItem(id: 'e12', title: 'Tagline', prompt: 'Luxury tagline for VYROX', type: CreationType.text, seed: 133, category: 'Text'),
];
