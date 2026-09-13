import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';

void openVip(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const VipScreen()),
  );
}

class VipBadge extends StatelessWidget {
  const VipBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openVip(context),
      borderRadius: BorderRadius.circular(VyroxRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: VyroxColors.goldSoft,
          borderRadius: BorderRadius.circular(VyroxRadius.sm),
          border: Border.all(color: VyroxColors.gold),
        ),
        child: const Text(
          'VIP',
          style: TextStyle(
            color: VyroxColors.gold,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class VipPromoCard extends StatelessWidget {
  const VipPromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
      child: VyroxCard(
        raised: true,
        onTap: () => openVip(context),
        child: Row(
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: VyroxColors.goldSoft,
                borderRadius: BorderRadius.circular(VyroxRadius.sm),
              ),
              child: const Icon(Icons.workspace_premium, color: VyroxColors.gold),
            ),
            const SizedBox(width: VyroxSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Go VIP', style: type.heading),
                  const SizedBox(height: 2),
                  Text(
                    'Turbo speed, HD output, no watermark',
                    style: type.caption,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: VyroxColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class VipScreen extends StatefulWidget {
  const VipScreen({super.key});

  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  bool _yearly = true;

  static const List<String> _features = <String>[
    'Turbo generation queue',
    'HD & 4K exports',
    'No watermark',
    'Unlimited daily creations',
    'Early access to new tools',
    'Priority support',
  ];

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(VyroxSpace.xl),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(VyroxSpace.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFF3B2A6E), VyroxColors.accentDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(VyroxRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.workspace_premium,
                    color: VyroxColors.gold, size: 36),
                const SizedBox(height: VyroxSpace.md),
                Text('VYROX VIP', style: type.display),
                const SizedBox(height: VyroxSpace.xs),
                Text(
                  'Unlock the full studio.',
                  style: type.bodyMuted.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: VyroxSpace.xl),
          for (final String f in _features)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: VyroxSpace.sm),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.check_circle,
                      color: VyroxColors.success, size: 20),
                  const SizedBox(width: VyroxSpace.md),
                  Expanded(child: Text(f, style: type.body)),
                ],
              ),
            ),
          const SizedBox(height: VyroxSpace.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: _PlanOption(
                  title: 'Monthly',
                  price: '₹299 / mo',
                  selected: !_yearly,
                  onTap: () => setState(() => _yearly = false),
                ),
              ),
              const SizedBox(width: VyroxSpace.md),
              Expanded(
                child: _PlanOption(
                  title: 'Yearly',
                  price: '₹1,999 / yr',
                  badge: 'Save 44%',
                  selected: _yearly,
                  onTap: () => setState(() => _yearly = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: VyroxSpace.xl),
          VyroxPrimaryButton(
            label: 'Continue',
            icon: Icons.lock_open,
            onPressed: () => showVyroxToast(
              context,
              'Billing arrives in a later stage (${_yearly ? 'yearly' : 'monthly'})',
            ),
          ),
          const SizedBox(height: VyroxSpace.md),
          Text(
            'Cancel anytime. Prices are placeholders.',
            style: type.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Material(
      color: selected ? VyroxColors.surfaceRaised : VyroxColors.surface,
      borderRadius: BorderRadius.circular(VyroxRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VyroxRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(VyroxSpace.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(VyroxRadius.lg),
            border: Border.all(
              color: selected ? VyroxColors.accent : VyroxColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: type.heading),
              const SizedBox(height: VyroxSpace.xs),
              Text(price, style: type.bodyMuted),
              if (badge != null) ...<Widget>[
                const SizedBox(height: VyroxSpace.sm),
                Text(
                  badge!,
                  style: type.label.copyWith(color: VyroxColors.gold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
