import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Image', 'Video', 'Sound'];
    final items = [
      {'title': 'Neon alley', 'sub': 'Rainy neon alley, cinematic', 'tag': 'Image'},
      {'title': 'Trailer cut', 'sub': 'Epic trailer camera push-in', 'tag': 'Video'},
      {'title': 'Low drone', 'sub': 'Dark ambient drone in D minor', 'tag': 'Sound'},
      {'title': 'Hook copy', 'sub': 'Catchy hook for intro', 'tag': 'Text'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Explore',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -3,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Community mock feed. Use any prompt in Create.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Filter chips
              Wrap(
                spacing: 10,
                children: filters.map((f) {
                  final active = f == 'All';
                  return Chip(
                    label: Text(f),
                    backgroundColor: active ? const Color(0xFF7B4FCE) : const Color(0xFF211C2D),
                    labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Mock feed items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final it = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181228),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it['title']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          it['sub']!,
                          style: const TextStyle(fontSize: 14, color: Colors.white60),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: it['tag'] == 'Image'
                                ? const Color(0xFF7B4FCE).withOpacity(0.25)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            it['tag']!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // This extra space kills the overflow
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
