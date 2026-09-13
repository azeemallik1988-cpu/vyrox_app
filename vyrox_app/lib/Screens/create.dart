import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'vip.dart';

void openTool(BuildContext context, CreationType type, {String? prompt}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CreateToolScreen(type: type, initialPrompt: prompt),
    ),
  );
}

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(title: 'Create', subtitle: 'Pick a tool to begin'),
        const VyroxSectionLabel('Tools'),
        ToolGrid(tools: CreationType.values),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}

class ToolGrid extends StatelessWidget {
  const ToolGrid({super.key, required this.tools});

  final List<CreationType> tools;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            childAspectRatio: 1.3,
            children: tools
                .map((CreationType t) => ToolTile(type: t))
                .toList(growable: false),
          );
        },
      ),
    );
  }
}

class ToolTile extends StatelessWidget {
  const ToolTile({super.key, required this.type});

  final CreationType type;

  @override
  Widget build(BuildContext context) {
    final VyroxType text = VyroxType.of(context);
    return VyroxCard(
      onTap: () => openTool(context, type),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: VyroxColors.accentSoft,
              borderRadius: BorderRadius.circular(VyroxRadius.sm),
            ),
            child: Icon(type.icon, color: VyroxColors.accent, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(type.label, style: text.heading),
              Text(type.hint, style: text.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class CreateToolScreen extends StatefulWidget {
  const CreateToolScreen({super.key, required this.type, this.initialPrompt});

  final CreationType type;
  final String? initialPrompt;

  @override
  State<CreateToolScreen> createState() => _CreateToolScreenState();
}

class _CreateToolScreenState extends State<CreateToolScreen> {
  static const List<String> _styles = <String>[
    'Cinematic',
    'Realistic',
    'Anime',
    '3D',
    'Minimal',
    'Neon',
  ];
  static const List<String> _ratios = <String>['1:1', '4:5', '16:9', '9:16'];

  late final TextEditingController _controller;
  String _style = 'Cinematic';
  String _ratio = '1:1';
  bool _turbo = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPrompt ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate() {
    final String prompt = _controller.text.trim();
    if (prompt.isEmpty) {
      showVyroxToast(context, 'Describe what you want first');
      return;
    }
    VyroxScope.of(context).generate(
      type: widget.type,
      prompt: '$prompt · $_style · $_ratio',
      turbo: _turbo,
    );
    showVyroxToast(
      context,
      '${widget.type.label} queued${_turbo ? ' (Turbo)' : ''}',
    );
    Navigator.of(context).pop();
    vyroxTab.value = 3;
  }

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('${widget.type.label} generator')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const VyroxSectionLabel('Prompt'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
            child: TextField(
              controller: _controller,
              maxLines: 5,
              style: type.body,
              decoration: InputDecoration(
                hintText: 'Describe your ${widget.type.label.toLowerCase()}…',
              ),
            ),
          ),
          const VyroxSectionLabel('Style'),
          VyroxFilterBar(
            options: _styles,
            selected: _style,
            onChanged: (String v) => setState(() => _style = v),
          ),
          const VyroxSectionLabel('Aspect ratio'),
          VyroxFilterBar(
            options: _ratios,
            selected: _ratio,
            onChanged: (String v) => setState(() => _ratio = v),
          ),
          const VyroxSectionLabel('Speed'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
            child: Wrap(
              spacing: VyroxSpace.sm,
              runSpacing: VyroxSpace.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                VyroxChip(
                  label: 'Standard',
                  selected: !_turbo,
                  onSelected: () => setState(() => _turbo = false),
                ),
                VyroxChip(
                  label: '⚡ Turbo',
                  selected: _turbo,
                  onSelected: () => setState(() => _turbo = true),
                ),
                const VipBadge(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(VyroxSpace.xl),
            child: VyroxPrimaryButton(
              label: 'Generate ${widget.type.label}',
              onPressed: _generate,
            ),
          ),
        ],
      ),
    );
  }
}
