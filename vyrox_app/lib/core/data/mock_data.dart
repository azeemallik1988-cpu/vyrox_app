class MockProject {
  const MockProject({
    required this.title,
    required this.kind,
    required this.status,
  });

  final String title;
  final String kind;
  final String status;
}

class MockAsset {
  const MockAsset({
    required this.name,
    required this.type,
  });

  final String name;
  final String type;
}

class MockData {
  static const credits = 120;

  static const projects = <MockProject>[
    MockProject(title: 'Neon City Trailer', kind: 'Video', status: 'Ready'),
    MockProject(title: 'Brand Logo Set', kind: 'Image', status: 'Draft'),
    MockProject(title: 'Podcast Intro', kind: 'Audio', status: 'Ready'),
    MockProject(title: 'Product Demo', kind: 'Video', status: 'Rendering'),
  ];

  static const assets = <MockAsset>[
    MockAsset(name: 'hero_frame_01.png', type: 'Image'),
    MockAsset(name: 'voice_over.wav', type: 'Audio'),
    MockAsset(name: 'scene_cut.mp4', type: 'Video'),
    MockAsset(name: 'upscaled_poster.png', type: 'Image'),
  ];

  static const tools = <String>[
    'Text',
    'Image',
    'Video',
    'Music',
    'TTS',
    'Upscale',
    'Remove BG',
  ];
}
