import 'package:flutter/material.dart';

class ExploreDetailScreen extends StatelessWidget {
  const ExploreDetailScreen({super.key, this.title, this.sub, this.tag});

  final String? title;
  final String? sub;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Detail', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock preview card
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF181228),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Center(
                child: Icon(
                  (tag == 'Video')
                      ? Icons.videocam
                      : (tag == 'Sound')
                          ? Icons.audiotrack
                          : (tag == 'Image')
                              ? Icons.image
                              : Icons.menu,
                  size: 60,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tag pill
            if (tag != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B4FCE).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tag!,
                  style: const TextStyle(
                    color: Color(0xFFC8B8FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // Title
            Text(
              title ?? 'Prompt',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -2,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              sub ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.3),
            ),
            const SizedBox(height: 32),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  // Open Create with this prompt later
                  Navigator.pop(context);
                },
                child: const Text(
                  'Use this prompt',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
