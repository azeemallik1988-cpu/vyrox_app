import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'vip.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<(IconData, String)> _settings = <(IconData, String)>[
    (Icons.palette_outlined, 'Appearance'),
    (Icons.notifications_outlined, 'Notifications'),
    (Icons.help_outline, 'Help'),
    (Icons.privacy_tip_outlined, 'Privacy Policy'),
    (Icons.description_outlined, 'Terms'),
    (Icons.info_outline, 'About'),
  ];

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    final CreationsStore store = VyroxScope.of(context);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(title: 'Profile'),
        Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[VyroxColors.accentDeep, VyroxColors.accent],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: VyroxColors.border, width: 3),
                ),
                child: const Icon(Icons.person, size: 44, color: Colors.white),
              ),
              const SizedBox(height: VyroxSpace.md),
              Text('VYROX Creator', style: type.heading),
              const SizedBox(height: 2),
              Text('Sign-in arrives in a later stage', style: type.caption),
            ],
          ),
        ),
        const SizedBox(height: VyroxSpace.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: VyroxCard(
            raised: true,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Free plan', style: type.heading),
                      const SizedBox(height: 2),
                      Text(
                        '${store.credits} credits · ${store.items.length} creations',
                        style: type.caption,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => openVip(context),
                  style: TextButton.styleFrom(
                    foregroundColor: VyroxColors.gold,
                  ),
                  child: const Text('Upgrade'),
                ),
              ],
            ),
          ),
        ),
        const VyroxSectionLabel('Settings'),
        for (final (IconData icon, String label) in _settings)
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
            leading: Icon(icon, color: VyroxColors.accent),
            title: Text(label, style: type.body),
            trailing:
                const Icon(Icons.chevron_right, color: VyroxColors.textMuted),
            onTap: () => showVyroxToast(context, '$label — coming soon'),
          ),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}
