import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VyroxApp());
}

// =============================================================================
// DESIGN SYSTEM — TOKENS
// =============================================================================

class VyroxColors {
  VyroxColors._();

  static const Color background = Color(0xFF07080C);
  static const Color surface = Color(0xFF0F1117);
  static const Color surfaceRaised = Color(0xFF161925);
  static const Color border = Color(0xFF232838);

  static const Color accent = Color(0xFF9B6CFF);
  static const Color accentDeep = Color(0xFF6A3FE0);
  static const Color accentSoft = Color(0x339B6CFF);

  static const Color textPrimary = Color(0xFFF2F3F7);
  static const Color textSecondary = Color(0xFF9AA0B4);
  static const Color textMuted = Color(0xFF5F6578);

  static const Color success = Color(0xFF4ADE80);
}

class VyroxSpace {
  VyroxSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class VyroxRadius {
  VyroxRadius._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
}

class VyroxBreakpoints {
  VyroxBreakpoints._();

  static const double tablet = 700;
  static const double desktop = 1100;
}

// =============================================================================
// DESIGN SYSTEM — DYNAMIC TYPOGRAPHY
// Scales with viewport width: phones ~1.0, tablets/desktops up to 1.22.
// =============================================================================

class VyroxType {
  const VyroxType._(this.scale);

  final double scale;

  factory VyroxType.of(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double scale = (width / 390).clamp(0.92, 1.22).toDouble();
    return VyroxType._(scale);
  }

  TextStyle get display => TextStyle(
        fontSize: 32 * scale,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
        color: VyroxColors.textPrimary,
      );

  TextStyle get title => TextStyle(
        fontSize: 24 * scale,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: VyroxColors.textPrimary,
      );

  TextStyle get heading => TextStyle(
        fontSize: 17 * scale,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: VyroxColors.textPrimary,
      );

  TextStyle get body => TextStyle(
        fontSize: 15 * scale,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: VyroxColors.textPrimary,
      );

  TextStyle get bodyMuted => TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: VyroxColors.textSecondary,
      );

  TextStyle get label => TextStyle(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: VyroxColors.textMuted,
      );

  TextStyle get caption => TextStyle(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w400,
        color: VyroxColors.textSecondary,
      );
}

// =============================================================================
// DESIGN SYSTEM — THEME
// =============================================================================

class VyroxTheme {
  VyroxTheme._();

  static ThemeData dark() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: VyroxColors.accent,
      brightness: Brightness.dark,
    ).copyWith(
      primary: VyroxColors.accent,
      surface: VyroxColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: VyroxColors.background,
      dividerTheme: const DividerThemeData(
        color: VyroxColors.border,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: VyroxColors.surface,
        indicatorColor: VyroxColors.accentSoft,
        height: 68,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: VyroxColors.surface,
        indicatorColor: VyroxColors.accentSoft,
        selectedIconTheme: IconThemeData(color: VyroxColors.accent),
        unselectedIconTheme: IconThemeData(color: VyroxColors.textSecondary),
        selectedLabelTextStyle: TextStyle(
          color: VyroxColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(color: VyroxColors.textSecondary),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: VyroxColors.surface,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: VyroxColors.surfaceRaised,
        contentTextStyle: TextStyle(color: VyroxColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VyroxColors.surface,
        hintStyle: const TextStyle(color: VyroxColors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VyroxRadius.md),
          borderSide: const BorderSide(color: VyroxColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VyroxRadius.md),
          borderSide: const BorderSide(color: VyroxColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VyroxRadius.md),
          borderSide: const BorderSide(color: VyroxColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

void showVyroxToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

// =============================================================================
// APP ROOT
// =============================================================================

class VyroxApp extends StatelessWidget {
  const VyroxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VYROX AI Studio',
      debugShowCheckedModeBanner: false,
      theme: VyroxTheme.dark(),
      home: const VyroxShell(),
    );
  }
}

// =============================================================================
// SHELL SCOPE — lets any screen open/toggle the side panel
// =============================================================================

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
  bool updateShouldNotify(VyroxShellScope oldWidget) {
    return isWide != oldWidget.isWide;
  }
}

// =============================================================================
// RESPONSIVE SHELL
// phone   : bottom NavigationBar + swipe-in end drawer panel
// tablet  : NavigationRail (icons + labels) + collapsible side panel
// desktop : extended NavigationRail + persistent side panel
// =============================================================================

class VyroxDestination {
  const VyroxDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
}

class VyroxShell extends StatefulWidget {
  const VyroxShell({super.key});

  @override
  State<VyroxShell> createState() => _VyroxShellState();
}

class _VyroxShellState extends State<VyroxShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _index = 0;
  bool _panelOpen = true;

  static const List<VyroxDestination> _destinations = <VyroxDestination>[
    VyroxDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      page: HomeScreen(),
    ),
    VyroxDestination(
      label: 'Create',
      icon: Icons.auto_awesome_outlined,
      selectedIcon: Icons.auto_awesome,
      page: CreateScreen(),
    ),
    VyroxDestination(
      label: 'Projects',
      icon: Icons.video_library_outlined,
      selectedIcon: Icons.video_library,
      page: ProjectsScreen(),
    ),
    VyroxDestination(
      label: 'Assets',
      icon: Icons.collections_outlined,
      selectedIcon: Icons.collections,
      page: AssetsScreen(),
    ),
    VyroxDestination(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      page: ProfileScreen(),
    ),
  ];

  void _select(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool isWide = width >= VyroxBreakpoints.tablet;
        final bool isDesktop = width >= VyroxBreakpoints.desktop;

        final Widget content = IndexedStack(
          index: _index,
          children: _destinations
              .map((VyroxDestination d) => d.page)
              .toList(growable: false),
        );

        if (!isWide) {
          return VyroxShellScope(
            isWide: false,
            togglePanel: () => _scaffoldKey.currentState?.openEndDrawer(),
            child: Scaffold(
              key: _scaffoldKey,
              body: content,
              endDrawer: const Drawer(
                width: 300,
                child: VyroxSidePanel(),
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: _select,
                destinations: _destinations
                    .map(
                      (VyroxDestination d) => NavigationDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: d.label,
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          );
        }

        return VyroxShellScope(
          isWide: true,
          togglePanel: () {
            setState(() {
              _panelOpen = !_panelOpen;
            });
          },
          child: Scaffold(
            key: _scaffoldKey,
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: _select,
                  extended: isDesktop,
                  labelType: isDesktop
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: VyroxSpace.lg),
                    child: VyroxLogo(size: 40),
                  ),
                  destinations: _destinations
                      .map(
                        (VyroxDestination d) => NavigationRailDestination(
                          icon: Icon(d.icon),
                          selectedIcon: Icon(d.selectedIcon),
                          label: Text(d.label),
                        ),
                      )
                      .toList(growable: false),
                ),
                const VerticalDivider(),
                Expanded(child: content),
                ClipRect(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    width: _panelOpen ? 300 : 0,
                    child: const OverflowBox(
                      alignment: Alignment.centerLeft,
                      minWidth: 300,
                      maxWidth: 300,
                      child: Row(
                        children: <Widget>[
                          VerticalDivider(),
                          Expanded(child: VyroxSidePanel()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// SHARED COMPONENTS
// =============================================================================

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
          crossAxisAlignment: CrossAxisAlignment.center,
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

class ProjectRow extends StatelessWidget {
  const ProjectRow({
    super.key,
    required this.name,
    required this.meta,
    this.icon = Icons.play_arrow_rounded,
  });

  final String name;
  final String meta;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VyroxSpace.xl,
        0,
        VyroxSpace.xl,
        VyroxSpace.sm,
      ),
      child: VyroxCard(
        padding: const EdgeInsets.all(VyroxSpace.md),
        onTap: () => showVyroxToast(context, 'Opening $name'),
        child: Row(
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: VyroxColors.surfaceRaised,
                borderRadius: BorderRadius.circular(VyroxRadius.sm),
              ),
              child: Icon(icon, color: VyroxColors.accent),
            ),
            const SizedBox(width: VyroxSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: type.heading),
                  const SizedBox(height: 2),
                  Text(meta, style: type.caption),
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

// =============================================================================
// SIDE PANEL (workspace)
// =============================================================================

class VyroxSidePanel extends StatelessWidget {
  const VyroxSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return ColoredBox(
      color: VyroxColors.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(VyroxSpace.lg),
          children: <Widget>[
            Row(
              children: <Widget>[
                const VyroxLogo(size: 30),
                const SizedBox(width: VyroxSpace.sm),
                Text('Workspace', style: type.heading),
              ],
            ),
            const SizedBox(height: VyroxSpace.xl),
            Text('OVERVIEW', style: type.label),
            const SizedBox(height: VyroxSpace.sm),
            const _PanelStat(label: 'Credits', value: '120'),
            const _PanelStat(label: 'Projects', value: '5'),
            const _PanelStat(label: 'Storage used', value: '1.2 GB'),
            const SizedBox(height: VyroxSpace.xl),
            Text('ACTIVITY', style: type.label),
            const SizedBox(height: VyroxSpace.sm),
            const _PanelActivity(
              text: 'Product teaser rendered',
              time: '2h ago',
            ),
            const _PanelActivity(
              text: 'Logo concepts saved',
              time: 'Yesterday',
            ),
            const _PanelActivity(
              text: 'Podcast intro exported',
              time: '3d ago',
            ),
            const SizedBox(height: VyroxSpace.xl),
            VyroxCard(
              raised: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.tips_and_updates_outlined,
                      color: VyroxColors.accent),
                  const SizedBox(height: VyroxSpace.sm),
                  Text('Pro tip', style: type.heading),
                  const SizedBox(height: VyroxSpace.xs),
                  Text(
                    'Describe lighting, mood and camera angle for sharper results.',
                    style: type.bodyMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelStat extends StatelessWidget {
  const _PanelStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VyroxSpace.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: type.bodyMuted),
          Text(value, style: type.heading),
        ],
      ),
    );
  }
}

class _PanelActivity extends StatelessWidget {
  const _PanelActivity({required this.text, required this.time});

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VyroxSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: VyroxSpace.md),
            decoration: const BoxDecoration(
              color: VyroxColors.success,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(text, style: type.body),
                Text(time, style: type.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// HOME
// =============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(
          title: 'VYROX AI',
          subtitle: 'Your AI creative studio',
          showLogo: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: Container(
            padding: const EdgeInsets.all(VyroxSpace.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[VyroxColors.accentDeep, VyroxColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(VyroxRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome back',
                  style: type.bodyMuted.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: VyroxSpace.xs),
                Text(
                  'What will you create today?',
                  style: type.display.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const VyroxSectionLabel('Quick actions'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double w = constraints.maxWidth;
              final int columns = w > 900 ? 4 : (w > 520 ? 3 : 2);
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: VyroxSpace.md,
                crossAxisSpacing: VyroxSpace.md,
                childAspectRatio: 1.35,
                children: const <Widget>[
                  ActionTile(
                    icon: Icons.image_outlined,
                    label: 'Image',
                    hint: 'Text to image',
                  ),
                  ActionTile(
                    icon: Icons.movie_outlined,
                    label: 'Video',
                    hint: 'Cinematic clips',
                  ),
                  ActionTile(
                    icon: Icons.graphic_eq,
                    label: 'Sound',
                    hint: 'Voice & music',
                  ),
                  ActionTile(
                    icon: Icons.text_fields,
                    label: 'Text',
                    hint: 'Copy & scripts',
                  ),
                ],
              );
            },
          ),
        ),
        const VyroxSectionLabel('Recent'),
        const ProjectRow(name: 'Product teaser', meta: 'Video • 2 hours ago'),
        const ProjectRow(
          name: 'Logo concepts',
          meta: 'Image • Yesterday',
          icon: Icons.image_outlined,
        ),
        const ProjectRow(
          name: 'Podcast intro',
          meta: 'Sound • 3 days ago',
          icon: Icons.graphic_eq,
        ),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
  });

  final IconData icon;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return VyroxCard(
      onTap: () => showVyroxToast(context, '$label generator — Stage 2'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: VyroxColors.accentSoft,
              borderRadius: BorderRadius.circular(VyroxRadius.sm),
            ),
            child: Icon(icon, color: VyroxColors.accent, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: type.heading),
              Text(hint, style: type.caption),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CREATE
// =============================================================================

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  static const List<String> _types = <String>['Image', 'Video', 'Sound', 'Text'];
  static const List<String> _modes = <String>['Standard', 'Turbo'];

  final TextEditingController _controller = TextEditingController();
  String _type = 'Image';
  String _mode = 'Standard';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate() {
    final String prompt = _controller.text.trim();
    if (prompt.isEmpty) {
      showVyroxToast(context, 'Describe what you want to create first');
      return;
    }
    showVyroxToast(context, 'Queued $_type ($_mode): "$prompt"');
  }

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(
          title: 'Create',
          subtitle: 'Describe it. VYROX makes it.',
        ),
        const VyroxSectionLabel('Output'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: Wrap(
            spacing: VyroxSpace.sm,
            runSpacing: VyroxSpace.sm,
            children: _types
                .map(
                  (String t) => VyroxChip(
                    label: t,
                    selected: t == _type,
                    onSelected: () => setState(() => _type = t),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const VyroxSectionLabel('Prompt'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: TextField(
            controller: _controller,
            maxLines: 6,
            style: type.body,
            decoration: const InputDecoration(
              hintText:
                  'A neon-lit city at night, rain on glass, cinematic lighting…',
            ),
          ),
        ),
        const VyroxSectionLabel('Speed'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: Wrap(
            spacing: VyroxSpace.sm,
            children: _modes
                .map(
                  (String m) => VyroxChip(
                    label: m == 'Turbo' ? '⚡ Turbo' : m,
                    selected: m == _mode,
                    onSelected: () => setState(() => _mode = m),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(VyroxSpace.xl),
          child: VyroxPrimaryButton(
            label: 'Generate $_type',
            onPressed: _generate,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// PROJECTS
// =============================================================================

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  static const List<String> _filters = <String>[
    'All',
    'Image',
    'Video',
    'Sound',
    'Text',
  ];

  static const List<List<String>> _items = <List<String>>[
    <String>['Product teaser', 'Video', '2 hours ago'],
    <String>['Logo concepts', 'Image', 'Yesterday'],
    <String>['Podcast intro', 'Sound', '3 days ago'],
    <String>['Ad copy set', 'Text', 'Last week'],
    <String>['Album art', 'Image', 'Last week'],
  ];

  String _filter = 'All';

  IconData _iconFor(String kind) {
    switch (kind) {
      case 'Image':
        return Icons.image_outlined;
      case 'Video':
        return Icons.movie_outlined;
      case 'Sound':
        return Icons.graphic_eq;
      default:
        return Icons.text_fields;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> visible = _items
        .where((List<String> i) => _filter == 'All' || i[1] == _filter)
        .toList(growable: false);

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(
          title: 'Projects',
          subtitle: 'Everything you have made',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: Wrap(
            spacing: VyroxSpace.sm,
            runSpacing: VyroxSpace.sm,
            children: _filters
                .map(
                  (String f) => VyroxChip(
                    label: f,
                    selected: f == _filter,
                    onSelected: () => setState(() => _filter = f),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: VyroxSpace.xl),
        for (final List<String> item in visible)
          ProjectRow(
            name: item[0],
            meta: '${item[1]} • ${item[2]}',
            icon: _iconFor(item[1]),
          ),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}

// =============================================================================
// ASSETS
// =============================================================================

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const VyroxHeader(title: 'Assets', subtitle: 'Your generated media'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double w = constraints.maxWidth;
              final int columns = w > 900 ? 6 : (w > 520 ? 4 : 3);
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: VyroxSpace.md,
                crossAxisSpacing: VyroxSpace.md,
                children: List<Widget>.generate(12, (int i) {
                  final IconData icon = i % 3 == 0
                      ? Icons.movie_outlined
                      : (i % 3 == 1
                          ? Icons.image_outlined
                          : Icons.graphic_eq);
                  return VyroxCard(
                    padding: EdgeInsets.zero,
                    onTap: () => showVyroxToast(context, 'Asset ${i + 1}'),
                    child: Center(
                      child: Icon(icon, color: VyroxColors.accent, size: 28),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}

// =============================================================================
// PROFILE
// =============================================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
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
              Text('creator@vyrox.ai', style: type.caption),
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
                      Text('120 credits remaining', style: type.caption),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      showVyroxToast(context, 'Upgrade flow — Stage 9'),
                  style: TextButton.styleFrom(
                    foregroundColor: VyroxColors.accent,
                  ),
                  child: const Text('Upgrade'),
                ),
              ],
            ),
          ),
        ),
        const VyroxSectionLabel('Account'),
        const SettingRow(icon: Icons.settings_outlined, label: 'Settings'),
        const SettingRow(icon: Icons.palette_outlined, label: 'Appearance'),
        const SettingRow(icon: Icons.help_outline, label: 'Help & support'),
        const SettingRow(icon: Icons.info_outline, label: 'About VYROX AI'),
        const SizedBox(height: VyroxSpace.xxl),
      ],
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: VyroxSpace.xl),
      leading: Icon(icon, color: VyroxColors.accent),
      title: Text(label, style: VyroxType.of(context).body),
      trailing: const Icon(Icons.chevron_right, color: VyroxColors.textMuted),
      onTap: () => showVyroxToast(context, '$label — coming in a later stage'),
    );
  }
}
