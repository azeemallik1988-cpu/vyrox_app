import 'package:flutter/material.dart';

/// YOUR FREE API KEYS HERE. Leave blank to disable that engine.
/// Gemini: https://aistudio.google.com (free, 15 req/min)
/// Cloudflare: https://dash.cloudflare.com (10k neurons/day free)
class EngineKeys {
  static const String gemini = '';
  static const String cloudflareAccount = '';
  static const String cloudflareToken = '';
  // ⬇️'SG_2c9a121c980622c7';  // PASTE YOUR FREE SEGMIND KEY HERE (from segmind.com)
  static const String segmind = '';
}

class AiEngine {
  final String id;
  final String label;
  final String description;
  final IconData icon;
  final bool requiresKey;
  final bool isReady;

  const AiEngine({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.requiresKey,
    required this.isReady,
  });
}

final List<AiEngine> allEngines = [
  AiEngine(
    id: 'auto',
    label: 'Auto',
    description: 'Smart',
    icon: Icons.auto_awesome,
    requiresKey: false,
    isReady: true,
  ),
  AiEngine(
    id: 'flux',
    label: 'FLUX',
    description: 'Pro quality',
    icon: Icons.brush,
    requiresKey: false,
    isReady: true,
  ),
  AiEngine(
    id: 'turbo',
    label: 'Turbo',
    description: 'Fastest',
    icon: Icons.bolt,
    requiresKey: false,
    isReady: true,
  ),
  AiEngine(
    id: 'kontext',
    label: 'Kontext',
    description: 'Context',
    icon: Icons.psychology,
    requiresKey: false,
    isReady: true,
  ),
  AiEngine(
    id: 'gemini',
    label: 'Gemini',
    description: 'Google',
    icon: Icons.workspace_premium,
    requiresKey: true,
    isReady: EngineKeys.gemini.isNotEmpty,
  ),
  AiEngine(
    id: 'cloudflare',
    label: 'Cloud',
    description: 'CF AI',
    icon: Icons.cloud,
    requiresKey: true,
    isReady: EngineKeys.cloudflareAccount.isNotEmpty &&
        EngineKeys.cloudflareToken.isNotEmpty,
  ),
];

String buildPollinationsUrl({
  required String engineId,
  required String prompt,
  required int width,
  required int height,
  required int seed,
}) {
  final encoded = Uri.encodeComponent(prompt);
  final model = (engineId == 'auto') ? '' : '&model=$engineId';
  return 'https://image.pollinations.ai/prompt/$encoded'
      '?width=$width&height=$height&nologo=true&seed=$seed$model';
}

List<String> buildCascadeOrder(String preferred) {
  const fallbackOrder = ['flux', 'turbo', 'kontext'];
  final list = <String>[];
  if (preferred != 'auto' && preferred != 'gemini' && preferred != 'cloudflare') {
    list.add(preferred);
  }
  list.addAll(fallbackOrder.where((e) => e != preferred));
  return list;
}
