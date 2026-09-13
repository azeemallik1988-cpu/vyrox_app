import 'package:flutter/material.dart';

import 'theme.dart';

class VyroxShellScope extends InheritedWidget {
  const VyroxShellScope({
    super.key,
    required this.isWide,
    required this.togglePanel,
    required super.child,
  });

  final bool isWide;
  final VoidCallback togglePanel;

  static VyroxShellScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VyroxShellScope>();
  }

  @override
  bool updateShouldNotify(VyroxShellScope oldWidget) =>
      isWide != oldWidget.isWide;
}

class VyroxLogo extends StatelessWidget {
  const VyroxLogo({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[VyroxColors.accentDeep, VyroxColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(Icons.bolt, color: Colors.white, size: size * 0.6),
    );
  }
}

class VyroxHeader extends StatelessWidget {
  const VyroxHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = false,
  });

  final String title;
  final String? subtitle;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    final VyroxShellScope? scope = VyroxShellScope.maybeOf(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          VyroxSpace.xl,
          VyroxSpace.xl,
          VyroxSpace.lg,
          VyroxSpace.lg,
        ),
        child: Row(
          children: <Widget>[
            if (showLogo) ...<Widget>[
              const VyroxLogo(),
              const SizedBox(width: VyroxSpace.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: type.title),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: VyroxSpace.xs),
                    Text(subtitle!, style: type.bodyMuted),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: 'Workspace panel',
              onPressed: scope?.togglePanel,
              icon: const Icon(
                Icons.view_sidebar_outlined,
                color: VyroxColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VyroxSectionLabel extends StatelessWidget {
  const VyroxSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VyroxSpace.xl,
        VyroxSpace.xl,
        VyroxSpace.xl,
        VyroxSpace.md,
      ),
      child: Text(text.toUpperCase(), style: VyroxType.of(context).label),
    );
  }
}

class VyroxCard extends StatelessWidget {
  const VyroxCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(VyroxSpace.lg),
    this.onTap,
    this.raised = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool raised;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(VyroxRadius.lg);
    return Material(
      color: raised ? VyroxColors.surfaceRaised : VyroxColors.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: VyroxColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class VyroxPrimaryButton extends StatelessWidget {
  const VyroxPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[VyroxColors.accentDeep, VyroxColors.accent],
          ),
          borderRadius: BorderRadius.circular(VyroxRadius.md),
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon ?? Icons.auto_awesome, size: 20),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VyroxRadius.md),
            ),
          ),
        ),
      ),
    );
  }
}

class VyroxChip extends StatelessWidget {
  const VyroxChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool _) => onSelected(),
      showCheckmark: false,
      selectedColor: VyroxColors.accent,
      backgroundColor: VyroxColors.surface,
      side: BorderSide(
        color: selected ? VyroxColors.accent : VyroxColors.border,
      ),
      labelStyle: TextStyle(
        color: selected ? Colors.white : VyroxColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VyroxRadius.sm),
      ),
    );
  }
}

class VyroxFilterBar extends StatelessWidget {
  const VyroxFilterBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
      child: Wrap(
        spacing: VyroxSpace.sm,
        runSpacing: VyroxSpace.sm,
        children: options
            .map(
              (String o) => VyroxChip(
                label: o,
                selected: o == selected,
                onSelected: () => onChanged(o),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class VyroxEmptyState extends StatelessWidget {
  const VyroxEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Padding(
      padding: const EdgeInsets.all(VyroxSpace.xxl),
      child: Column(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: VyroxColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: VyroxColors.accent, size: 30),
          ),
          const SizedBox(height: VyroxSpace.lg),
          Text(title, style: type.heading, textAlign: TextAlign.center),
          const SizedBox(height: VyroxSpace.xs),
          Text(message, style: type.bodyMuted, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Deterministic gradient placeholder derived from a seed (no network images).
class SeedThumb extends StatelessWidget {
  const SeedThumb({
    super.key,
    required this.seed,
    this.icon,
    this.radius = VyroxRadius.md,
    this.child,
  });

  final int seed;
  final IconData? icon;
  final double radius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double hue = (seed * 47 % 360).toDouble();
    final Color a = HSLColor.fromAHSL(1, hue, 0.55, 0.32).toColor();
    final Color b = HSLColor.fromAHSL(1, (hue + 50) % 360, 0.65, 0.55).toColor();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[a, b],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (icon != null)
              Center(child: Icon(icon, color: Colors.white70, size: 30)),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
