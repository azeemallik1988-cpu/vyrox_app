import 'package:flutter/material.dart';

class AITransformScreen extends StatelessWidget {
  final String mode;
  final String title;
  const AITransformScreen({super.key, required this.mode, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 64, color: Color(0xFF7B4FCE)),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('AI engine loading in the next update...', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
