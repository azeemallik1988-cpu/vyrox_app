import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'create.dart';
import 'creations.dart' show kGroupFilters;

class ExploreItem {
  const ExploreItem(this.title, this.author, this.type, this.seed, this.prompt);

  final String title;
  final String author;
  final CreationType type;
  final int seed;
  final String prompt;
}

const List<ExploreItem> kExploreItems = <ExploreItem>[
  ExploreItem('Neon Rain', 'aiko', CreationType.image, 11,
      'Neon-lit Tokyo alley at night, rain on glass, cinematic lighting'),
  ExploreItem('Desert Drift', 'marco', CreationType.video, 22,
      'Slow aerial drift over golden dunes at sunset, volumetric haze'),
  ExploreItem('Lo-fi Loop', 'nova', CreationType.music, 33,
      'Warm lo-fi hip hop loop, vinyl crackle, 82 bpm'),
  ExploreItem('Product Hero', 'dev', CreationType.image, 44,
      'Matte black headphones on marble, soft studio light, 3D render'),
  ExploreItem('Founder Intro', 'sara', CreationType.sound, 55,
      'Confident female voiceover, 20 seconds, startup launch teaser'),
  ExploreItem('Brand Story', 'liam', CreationType.text, 66,
      'Write a 3-paragraph brand story for a sustainable coffee label'),
  ExploreItem('Cyber Portrait', 'zed', CreationType.avatar, 77,
      'Futuristic portrait, chrome visor, violet rim light, ultra detail'),
  ExploreItem('Ocean Macro', 'mia', CreationType.image, 88,
      'Macro shot of a wave curling, crystal water, 100mm lens'),
  ExploreItem('Retro Ad', 'kai', CreationType.video, 99,
      '1980s TV commercial style, VHS grain, upbeat, 10 seconds'),
  ExploreItem('Synthwave', 'nova', CreationType.music, 111,
      'Driving synthwave track, arpeggios, 120 bpm, 30 seconds'),
  ExploreItem('Minimal Logo', 'ana', CreationType.image, 122,
      'Minimal geometric logo mark, monochrome, negative space'),
  ExploreItem('Podcast Cold Open', 'raj', CreationType.text, 133,
      'Write a punchy 45-second podcast cold open about AI creativity'),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final List<ExploreItem> visible = kExploreItems
        .where((ExploreItem e) => _filter == 'All' || e.type.group == _filter)
        .toList(growable: false);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(
          title: 'Explore',
          subtitle: 'What the community is making',
        ),
        VyroxFilterBar(
          options: kGroupFilters,
          selected: _filter,
          onChanged: (String v) => setState(() => _filter = v),
        ),
        const SizedBox(height: VyroxSpace.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double w = constraints.maxWidth;
              final int columns = w > 900 ? 4 : (w > 520 ? 3 : 2);
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: VyroxSpace.md,
                crossAxisSpacing: VyroxSpace.md,
                childAspectRatio: 0.78,
                children: visible
                    .map((ExploreItem e) => _ExploreCard(item: e))
                    .toList(growable: false),
              );
            },
          ),
        ),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.item});

  final ExploreItem item;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return VyroxCard(
      padding: EdgeInsets.zero,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ExploreDetailScreen(item: item),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SeedThumb(
              seed: item.seed,
              icon: item.type.icon,
              radius: VyroxRadius.lg,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(VyroxSpace.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: type.heading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('@${item.author} · ${item.type.label}', style: type.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreDetailScreen extends StatelessWidget {
  const ExploreDetailScreen({super.key, required this.item});

  final ExploreItem item;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(VyroxSpace.xl),
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: SeedThumb(
              seed: item.seed,
              icon: item.type.icon,
              radius: VyroxRadius.lg,
            ),
          ),
          const SizedBox(height: VyroxSpace.lg),
          Text('@${item.author} · ${item.type.label}', style: type.caption),
          const SizedBox(height: VyroxSpace.lg),
          VyroxCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('PROMPT', style: type.label),
                const SizedBox(height: VyroxSpace.sm),
                Text(item.prompt, style: type.body),
              ],
            ),
          ),
          const SizedBox(height: VyroxSpace.xl),
          VyroxPrimaryButton(
            label: 'Use this prompt',
            icon: Icons.content_copy,
            onPressed: () => openTool(context, item.type, prompt: item.prompt),
          ),
        ],
      ),
    );
  }
}
