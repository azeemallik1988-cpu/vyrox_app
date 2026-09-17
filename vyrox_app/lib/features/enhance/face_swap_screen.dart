import 'package:flutter/material.dart';
import '../create/image_result_screen.dart';

class FaceSwapScreen extends StatefulWidget {
  const FaceSwapScreen({super.key});

  @override
  State<FaceSwapScreen> createState() => _FaceSwapScreenState();
}

class _FaceSwapScreenState extends State<FaceSwapScreen> {
  final TextEditingController _promptController = TextEditingController();
  int _selectedStyleIndex = 0;

  final List<Map<String, String>> _styles = const [
    {'name': 'Professional Suit', 'prompt': 'professional business headshot portrait, wearing elegant suit, studio lighting, highly detailed'},
    {'name': 'Cyberpunk Hero', 'prompt': 'futuristic cyberpunk warrior portrait, neon lighting, sci-fi outfit, cinematic 8k'},
    {'name': 'Royal King/Queen', 'prompt': 'royal portrait wearing golden crown and luxury velvet robe, majestic lighting, oil painting style'},
    {'name': 'Anime Portrait', 'prompt': 'anime style character portrait, vibrant colors, Makoto Shinkai aesthetic, detailed face'},
    {'name': 'Casual Model', 'prompt': 'trendy streetwear fashion photoshoot, natural sunlight, depth of field, 4k'},
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generateStylePortrait() {
    final customPrompt = _promptController.text.trim();
    final stylePrompt = _styles[_selectedStyleIndex]['prompt']!;
    final finalPrompt = customPrompt.isEmpty ? stylePrompt : '$customPrompt, $stylePrompt';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageResultScreen(
          prompt: finalPrompt,
          style: _styles[_selectedStyleIndex]['name']!,
          aspectRatio: '1:1',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('AI Avatar & Face Studio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B4FCE), Color(0xFF3B82F6)],
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.face, color: Colors.white, size: 36),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Avatar Creator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 2),
                        Text('Generate hyper-realistic portraits & face styles instantly', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Preset Style Picker
            const Text('Select Face Style Preset', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _styles.length,
              itemBuilder: (context, index) {
                final selected = _selectedStyleIndex == index;
                final style = _styles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedStyleIndex = index),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF7B4FCE).withOpacity(0.2) : const Color(0xFF181228),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.06),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected ? Icons.check_circle : Icons.circle_outlined,
                            color: selected ? const Color(0xFFC8F560) : Colors.white38,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              style['name']!,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white70,
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Custom Description Field
            const Text('Custom Face Details (Optional)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF181228),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: TextField(
                controller: _promptController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'e.g. "Indian man with glasses and smile"',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                onPressed: _generateStylePortrait,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Avatar Portrait', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
