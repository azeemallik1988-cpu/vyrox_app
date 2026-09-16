import 'package:flutter/material.dart';

class CreateToolScreen extends StatefulWidget {
  const CreateToolScreen({super.key, this.tool});

  // Matches the String-based calls in your current Home and Create hub.
  final String? tool;

  @override
  State<CreateToolScreen> createState() => _CreateToolScreenState();
}

class _CreateToolScreenState extends State<CreateToolScreen> {
  static const _background = Color(0xFF0F0C17);
  static const _surface = Color(0xFF181228);
  static const _purple = Color(0xFF7B4FCE);

  final _promptController = TextEditingController();

  // Stores each group's selection separately.
  final Map<String, String> _selectedOptions = {};

  String get _tool => widget.tool ?? 'Image';

  @override
  void didUpdateWidget(covariant CreateToolScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tool != widget.tool) {
      _selectedOptions.clear();
      _promptController.clear();
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Map<String, List<String>> _optionsFor(String tool) {
    switch (tool) {
      case 'Image':
      case 'Avatar':
        return const {
          'Style': ['Cinematic', 'Realistic', 'Anime', 'Noir'],
          'Aspect ratio': ['1:1', '16:9', '9:16'],
        };

      case 'Video':
        return const {
          'Duration': ['5s', '10s', '15s'],
          'Aspect ratio': ['16:9', '9:16', '1:1'],
        };

      case 'Sound':
      case 'Music':
        return const {
          'Genre': ['Ambient', 'Cinematic', 'Lo-fi', 'Epic'],
          'Length': ['30s', '1 min', '2 min'],
        };

      case 'Text':
        return const {
          'Tone': ['Formal', 'Casual', 'Creative', 'Marketing'],
        };

      case 'Upscale':
        return const {
          'Scale': ['2x', '4x', '8x'],
        };

      case 'Remove BG':
        return const {
          'Output': ['Transparent', 'White', 'Black'],
        };

      default:
        return const {};
    }
  }

  String _hintFor(String tool) {
    switch (tool) {
      case 'Video':
        return 'Describe your video scene...';
      case 'Sound':
        return 'Describe the sound or ambience...';
      case 'Music':
        return 'Describe the music mood and genre...';
      case 'Text':
        return 'What would you like to write?';
      case 'Avatar':
        return 'Describe your avatar...';
      case 'Upscale':
        return 'Add a note about the image you want to enhance...';
      case 'Remove BG':
        return 'Add a note about the background you want removed...';
      default:
        return 'Describe what you want to create...';
    }
  }

  Widget _buildOptionGroup(String title, List<String> options) {
    final selectedValue = _selectedOptions[title] ?? options.first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options)
                ChoiceChip(
                  label: Text(option),
                  selected: selectedValue == option,
                  onSelected: (isSelected) {
                    if (isSelected) {
                      setState(() {
                        _selectedOptions[title] = option;
                      });
                    }
                  },
                  showCheckmark: true,
                  checkmarkColor: Colors.white,
                  selectedColor: _purple,
                  backgroundColor: _surface,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _reviewSettings() {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a prompt or note first.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final groups = _optionsFor(_tool);
    final settings = groups.entries.map((entry) {
      final value = _selectedOptions[entry.key] ?? entry.value.first;
      return '${entry.key}: $value';
    }).join('\n');

    // UI demonstration only: no engine request or project save.
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          title: Text('$_tool settings'),
          content: Text(
            'Prompt:\n$prompt\n\n'
            '$settings\n\n'
            'Demo only. No media has been generated or saved.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final optionGroups = _optionsFor(_tool);
    final needsImage = _tool == 'Upscale' || _tool == 'Remove BG';

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _tool,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _promptController,
                minLines: 4,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _surface,
                  contentPadding: const EdgeInsets.all(20),
                  hintText: _hintFor(_tool),
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              for (final group in optionGroups.entries)
                _buildOptionGroup(group.key, group.value),

              if (needsImage) ...[
                const Text(
                  'Image upload and processing are not connected '
                  'in this demo yet.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const Text(
                'Demo mode: Generate reviews your prompt and settings only.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _reviewSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Generate $_tool (demo)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
