import 'package:flutter/material.dart';

class Stage2cHome extends StatelessWidget {
  const Stage2cHome({super.key});

  final List<Map<String, dynamic>> tools = const [
    {'icon': Icons.image, 'label': 'Image', 'tag': 'Free', 'tagColor': Color(0xFF9C6BFF)},
    {'icon': Icons.videocam, 'label': 'Video', 'tag': 'Turbo', 'tagColor': Color(0xFF4DA6FF)},
    {'icon': Icons.audiotrack, 'label': 'Sound', 'tag': null, 'tagColor': null},
    {'icon': Icons.text_fields, 'label': 'Text', 'tag': null, 'tagColor': null},
    {'icon': Icons.zoom_out_map, 'label': 'Upscale', 'tag': null, 'tagColor': null},
    {'icon': Icons.remove_circle_outline, 'label': 'Remove BG', 'tag': null, 'tagColor': null},
    {'icon': Icons.face_retouching_natural, 'label': 'Avatar', 'tag': null, 'tagColor': null},
    {'icon': Icons.music_note, 'label': 'Music', 'tag': null, 'tagColor': null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0812),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand mark top-left
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.stars, color: Colors.black, size: 20),
              ),
              const SizedBox(height: 16),
              // Main header
              const Text(
                'VYROX AI',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -3,
                  height: 0.95,
                ),
              ),
              const Text(
                'STUDIO',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -3,
                  height: 0.95,
                ),
              ),
              const SizedBox(height: 28),
              // Tool grid
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.05,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: tools.length,
                  itemBuilder: (context, index) {
                    final t = tools[index];
                    return GlassToolCard(
                      icon: t['icon'] as IconData,
                      label: t['label'] as String,
                      tag: t['tag'] as String?,
                      tagColor: t['tagColor'] as Color?,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF151023),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, 'Home', true),
          _navItem(Icons.auto_awesome, 'Create', false),
          _navItem(Icons.explore, 'Explore', false),
          _navItem(Icons.grid_view, 'Creations', false),
          _navItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: active
              ? BoxDecoration(color: const Color(0xFF7B4FE0), borderRadius: BorderRadius.circular(16))
              : null,
          child: Icon(icon, color: active ? Colors.white : Colors.white54, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? Colors.white : Colors.white54, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class GlassToolCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? tag;
  final Color? tagColor;

  const GlassToolCard({
    super.key,
    required this.icon,
    required this.label,
    this.tag,
    this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181220),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2D1B4E), width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2D1B4E).withOpacity(0.25),
            const Color(0xFF0D0A14).withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B4FE0).withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (tag != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: tagColor ?? Colors.purple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(tag!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
