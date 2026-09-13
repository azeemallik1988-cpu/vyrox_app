import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../core/widgets.dart';

const List<String> kGroupFilters = <String>[
  'All',
  'Images',
  'Videos',
  'Sounds',
  'Text',
];

class CreationsScreen extends StatefulWidget {
  const CreationsScreen({super.key});

  @override
  State<CreationsScreen> createState() => _CreationsScreenState();
}

class _CreationsScreenState extends State<CreationsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final CreationsStore store = VyroxScope.of(context);
    final List<Creation> visible = store.items
        .where((Creation c) => _filter == 'All' || c.type.group == _filter)
        .toList(growable: false);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(
          title: 'Creations',
          subtitle: 'Everything you have made',
        ),
        VyroxFilterBar(
          options: kGroupFilters,
          selected: _filter,
          onChanged: (String v) => setState(() => _filter = v),
        ),
        const SizedBox(height: VyroxSpace.xl),
        if (visible.isEmpty)
          const VyroxEmptyState(
            icon: Icons.auto_awesome_outlined,
            title: 'No creations yet',
            message: 'Open Create, pick a tool and hit Generate.',
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double w = constraints.maxWidth;
                final int columns = w > 900 ? 5 : (w > 520 ? 4 : 3);
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: VyroxSpace.md,
                  crossAxisSpacing: VyroxSpace.md,
                  children: visible
                      .map((Creation c) => CreationThumb(creation: c))
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

class CreationThumb extends StatelessWidget {
  const CreationThumb({super.key, required this.creation});

  final Creation creation;

  @override
  Widget build(BuildContext context) {
    final bool busy = creation.status == CreationStatus.generating ||
        creation.status == CreationStatus.queued;
    return InkWell(
      borderRadius: BorderRadius.circular(VyroxRadius.md),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CreationDetailScreen(creationId: creation.id),
        ),
      ),
      child: SeedThumb(
        seed: creation.thumbnailSeed,
        icon: busy ? null : creation.type.icon,
        child: Stack(
          children: <Widget>[
            if (busy)
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  creation.type.label,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreationDetailScreen extends StatelessWidget {
  const CreationDetailScreen({super.key, required this.creationId});

  final String creationId;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    final CreationsStore store = VyroxScope.of(context);
    final Creation? creation = store.byId(creationId);

    if (creation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const VyroxEmptyState(
          icon: Icons.delete_outline,
          title: 'Creation removed',
          message: 'This item no longer exists.',
        ),
      );
    }

    final bool done = creation.status == CreationStatus.done;

    return Scaffold(
      appBar: AppBar(title: Text(creation.type.label)),
      body: ListView(
        padding: const EdgeInsets.all(VyroxSpace.xl),
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: SeedThumb(
              seed: creation.thumbnailSeed,
              icon: creation.type.icon,
              radius: VyroxRadius.lg,
              child: done
                  ? const SizedBox.shrink()
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: VyroxSpace.lg),
          Row(
            children: <Widget>[
              Icon(
                done ? Icons.check_circle : Icons.hourglass_top,
                size: 18,
                color: done ? VyroxColors.success : VyroxColors.gold,
              ),
              const SizedBox(width: VyroxSpace.sm),
              Text(
                done ? 'Ready' : 'Generating…',
                style: type.caption,
              ),
              const Spacer(),
              Text(_formatDate(creation.createdAt), style: type.caption),
            ],
          ),
          const SizedBox(height: VyroxSpace.lg),
          VyroxCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('PROMPT', style: type.label),
                const SizedBox(height: VyroxSpace.sm),
                Text(creation.prompt, style: type.body),
              ],
            ),
          ),
          const SizedBox(height: VyroxSpace.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      showVyroxToast(context, 'Sharing arrives in a later stage'),
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: VyroxSpace.md),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: VyroxColors.danger,
                  ),
                  onPressed: () {
                    store.remove(creation.id);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
}
