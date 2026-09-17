import 'package:flutter/material.dart';
import '../../core/engines/ai_engines.dart';
import 'dart:math';

class TypographyScreen extends StatefulWidget {
  const TypographyScreen({super.key});

  @override
  State<TypographyScreen> createState() => _TypographyScreenState();
}

enum TypoTemplate { poster, logo, quote, wallpaper, tshirt }

class _TypographyScreenState extends State<TypographyScreen> {
  TypoTemplate _template = TypoTemplate.poster;
  final _bgPrompt = TextEditingController(text: 'dramatic dark purple smoke, minimal, void backdrop');
  final _mainText = TextEditingController(text: 'VYROX AI');
  final _subText = TextEditingController(text: 'IMAGINE · CREATE · SHIP');
  int _textColorIndex = 0;
  int _fontIndex = 0;
  bool _showText = true;

  final List<Color> _textColors = [Colors.white, Colors.black, const Color(0xFFC8F560), const Color(0xFFA78BFA)];
  final List<String> _fontLabels = ['Bold', 'Thin', 'Serif', 'Mono'];

  String? _bgUrl;
  bool _isLoading = false;

  (int, int) _sizeFor(TypoTemplate t) {
    switch (t) {
      case TypoTemplate.poster: return (1024, 1536);
      case TypoTemplate.logo: return (1024, 1024);
      case TypoTemplate.quote: return (1024, 1024);
      case TypoTemplate.wallpaper: return (1170, 2532);
      case TypoTemplate.tshirt: return (1024, 1024);
    }
  }

  Future<void> _generate() async {
    setState(() {
      _isLoading = true;
      _bgUrl = null;
    });
    final (w, h) = _sizeFor(_template);
    final url = buildPollinationsUrl(
      engineId: 'flux',
      prompt: '${_bgPrompt.text}, no text, no letters, no words, clean background',
      width: w,
      height: h,
      seed: Random().nextInt(999999),
    );
    setState(() {
      _bgUrl = url;
      _isLoading = false;
    });
  }

  double _aspect() {
    final (w, h) = _sizeFor(_template);
    return w / h;
  }

  TextAlign _alignFor() => TextAlign.center;

  @override
  Widget build(BuildContext context) {
    final textColor = _textColors[_textColorIndex];
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Typography Mode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Template', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: TypoTemplate.values.map((t) {
                  final selected = _template == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _template = t),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF7B4FCE) : const Color(0xFF181228),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Text(
                          t.name[0].toUpperCase() + t.name.substring(1),
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Preview
            AspectRatio(
              aspectRatio: _aspect(),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF181228),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_bgUrl != null)
                        Image.network(
                          _bgUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (c, child, p) => p == null
                              ? child
                              : const Center(child: CircularProgressIndicator(color: Color(0xFF7B4FCE))),
                          errorBuilder: (c, e, s) => const Center(
                            child: Icon(Icons.image_not_supported, color: Colors.white24, size: 48),
                          ),
                        )
                      else
                        const Center(
                          child: Icon(Icons.auto_awesome, color: Colors.white24, size: 48),
                        ),
                      if (_showText)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: _template == TypoTemplate.logo
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _mainText.text,
                                textAlign: _alignFor(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: _template == TypoTemplate.tshirt
                                      ? 42
                                      : _template == TypoTemplate.logo
                                          ? 56
                                          : 48,
                                  fontWeight: _fontIndex == 0
                                      ? FontWeight.w900
                                      : _fontIndex == 1
                                          ? FontWeight.w200
                                          : FontWeight.bold,
                                  letterSpacing: _fontIndex == 0 ? -1 : 2,
                                  height: 1.05,
                                  shadows: const [
                                    Shadow(color: Colors.black54, blurRadius: 20),
                                  ],
                                ),
                              ),
                              if (_subText.text.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  _subText.text,
                                  textAlign: _alignFor(),
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.75),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 4,
                                    shadows: const [Shadow(color: Colors.black54, blurRadius: 12)],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Background prompt
            const Text('Background prompt', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _bgPrompt,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF181228),
                hintStyle: const TextStyle(color: Colors.white38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),

            // Main text
            const Text('Main text', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _mainText,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF181228),
                hintText: 'YOUR BRAND',
                hintStyle: const TextStyle(color: Colors.white38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),

            // Sub text
            const Text('Subtitle (optional)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _subText,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF181228),
                hintText: 'tagline · URL · handle',
                hintStyle: const TextStyle(color: Colors.white38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 18),

            // Font weight
            const Text('Font weight', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _fontLabels.asMap().entries.map((e) {
                final sel = _fontIndex == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _fontIndex = e.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFF7B4FCE) : const Color(0xFF181228),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(e.value, style: TextStyle(color: sel ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Text color
            const Text('Text color', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: _textColors.asMap().entries.map((e) {
                final sel = _textColorIndex == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _textColorIndex = e.key),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: e.value,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: sel ? const Color(0xFF7B4FCE) : Colors.white24,
                          width: sel ? 3 : 1,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),

            // Generate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                onPressed: _isLoading ? null : _generate,
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Generate Background', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI generates the background, Vyrox renders the text — 100% crisp & legible.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
