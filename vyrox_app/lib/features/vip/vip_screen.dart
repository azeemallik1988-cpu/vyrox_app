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
      appBar: AppBar(title: const Text('VIP')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Go VIP', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Turbo, Avatar, and priority mock engines.', style: TextStyle(color: VyroxColors.muted)),
          const SizedBox(height: 24),
          const _Feature('Turbo generation badge'),
          const _Feature('Avatar + Sound tools'),
          const _Feature('Priority queue (mock)'),
          const _Feature('Watermark-free exports (mock)'),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Monthly'),
              Switch(
                value: yearly,
                onChanged: (value) => setState(() => yearly = value),
              ),
              const Text('Yearly'),
            ],
          ),
          Text(
            yearly ? '₹0 mock · billed yearly' : '₹0 mock · billed monthly',
            style: const TextStyle(color: VyroxColors.muted),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('VIP checkout is mocked in v1')),
              );
            },
            child: const Text('Continue'),
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
      leading: const Icon(Icons.check_circle, color: VyroxColors.accent),
      title: Text(text),
    );
  }
}
