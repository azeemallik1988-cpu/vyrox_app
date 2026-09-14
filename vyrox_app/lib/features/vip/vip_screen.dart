import 'package:flutter/material.dart';

import '../../core/theme/vyrox_theme.dart';

class VipScreen extends StatefulWidget {
  const VipScreen({super.key});

  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  bool yearly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyroxColors.bg,
      appBar: AppBar(title: const Text('VIP')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A1850), Color(0xFF7C5CFF), Color(0xFFD6FF4A)],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.workspace_premium, color: Colors.black, size: 32),
                Spacer(),
                Text('Go VIP', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Turbo, Avatar, and priority mock engines.', style: TextStyle(color: Color(0xFFB9B9C6))),
          const SizedBox(height: 16),
          const _Feature('Turbo generation badge'),
          const _Feature('Avatar + Sound tools'),
          const _Feature('Priority queue (mock)'),
          const _Feature('Watermark-free exports (mock)'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: VyroxColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: VyroxColors.line),
            ),
            child: Row(
              children: [
                const Text('Monthly'),
                Switch(
                  value: yearly,
                  onChanged: (value) => setState(() => yearly = value),
                ),
                const Text('Yearly'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            yearly ? '₹0 mock · billed yearly' : '₹0 mock · billed monthly',
            style: const TextStyle(color: Color(0xFFB9B9C6)),
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
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('VIP checkout is mocked in v1')),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
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

class _Feature extends StatelessWidget {
  const _Feature(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle, color: Color(0xFFB8FF4A)),
      title: Text(text),
    );
  }
}
