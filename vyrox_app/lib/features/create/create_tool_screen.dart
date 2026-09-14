import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/creation.dart';
import '../../core/state/creations_notifier.dart';
import '../../core/theme/vyrox_theme.dart';

class CreateToolScreen extends ConsumerStatefulWidget {
  const CreateToolScreen({
    super.key,
    required this.tool,
    this.initialPrompt = '',
  });

  final CreationType tool;
  final String initialPrompt;

  @override
  ConsumerState<CreateToolScreen> createState() => _CreateToolScreenState();
}

class _CreateToolScreenState extends ConsumerState<CreateToolScreen> {
  late final TextEditingController prompt;
  String style = 'Cinematic';
  String ratio = '1:1';
  bool turbo = false;

  static const styles = ['Cinematic', 'Realistic', 'Anime', 'Noir'];
  static const ratios = ['1:1', '16:9', '9:16'];

  @override
  void initState() {
    super.initState();
    prompt = TextEditingController(text: widget.initialPrompt);
  }

  @override
  void dispose() {
    prompt.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final text = prompt.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a prompt first')),
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final seed = text.hashCode.abs();
    ref.read(creationsProvider.notifier).add(
          Creation(
            id: id,
            type: widget.tool,
            prompt: text,
            status: CreationStatus.generating,
            createdAt: DateTime.now(),
            thumbnailSeed: seed,
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating ${widget.tool.label}…')),
    );
    context.go('/creations');

    Future<void>.delayed(const Duration(seconds: 3), () {
      ref.read(creationsProvider.notifier).markDone(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroxColors.bg,
      appBar: AppBar(
        title: Text(widget.tool.label),
        actions: [
          if (turbo)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => context.push('/vip'),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8FF4A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'VIP',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VyroxColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: VyroxColors.line),
            ),
            child: TextField(
              controller: prompt,
              maxLines: 6,
              style: const TextStyle(height: 1.4),
              decoration: const InputDecoration(
                hintText: 'Describe what you want to create…',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Style', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in styles)
                ChoiceChip(
                  label: Text(item),
                  selected: style == item,
                  onSelected: (_) => setState(() => style = item),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Aspect ratio', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final item in ratios)
                ChoiceChip(
                  label: Text(item),
                  selected: ratio == item,
                  onSelected: (_) => setState(() => ratio = item),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: VyroxColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: VyroxColors.line),
            ),
            child: Row(
              children: [
                const Text('Standard'),
                Switch(
                  value: turbo,
                  onChanged: (value) => setState(() => turbo = value),
                ),
                const Text('Turbo'),
                const Spacer(),
                if (turbo)
                  GestureDetector(
                    onTap: () => context.push('/vip'),
                    child: const Text(
                      'VIP',
                      style: TextStyle(
                        color: Color(0xFFB8FF4A),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C5CFF), Color(0xFFD6FF4A)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _generate,
                  borderRadius: BorderRadius.circular(18),
                  child: const Center(
                    child: Text(
                      'Generate',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
