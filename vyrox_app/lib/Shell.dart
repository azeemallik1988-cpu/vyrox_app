import 'package:flutter/material.dart';

import 'core/store.dart';
import 'core/theme.dart';
import 'core/widgets.dart';
import 'screens/create.dart';
import 'screens/creations.dart';
import 'screens/explore.dart';
import 'screens/home.dart';
import 'screens/profile.dart';

class _Destination {
  const _Destination(this.label, this.icon, this.selectedIcon, this.page);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
}

const List<_Destination> _destinations = <_Destination>[
  _Destination('Home', Icons.home_outlined, Icons.home, HomeScreen()),
  _Destination(
    'Create',
    Icons.auto_awesome_outlined,
    Icons.auto_awesome,
    CreateScreen(),
  ),
  _Destination('Explore', Icons.explore_outlined, Icons.explore, ExploreScreen()),
  _Destination(
    'Creations',
    Icons.collections_outlined,
    Icons.collections,
    CreationsScreen(),
  ),
  _Destination('Profile', Icons.person_outline, Icons.person, ProfileScreen()),
];

class VyroxShell extends StatefulWidget {
  const VyroxShell({super.key});

  @override
  State<VyroxShell> createState() => _VyroxShellState();
}

class _VyroxShellState extends State<VyroxShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _panelOpen = true;

  @override
  void initState() {
    super.initState();
    vyroxTab.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    vyroxTab.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _select(int index) {
    vyroxTab.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final int index = vyroxTab.value;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool isWide = width >= VyroxBreakpoints.tablet;
        final bool isDesktop = width >= VyroxBreakpoints.desktop;

        final Widget content = IndexedStack(
          index: index,
          children: _destinations
              .map((_Destination d) => d.page)
              .toList(growable: false),
        );

        if (!isWide) {
          return VyroxShellScope(
            isWide: false,
            togglePanel: () => _scaffoldKey.currentState?.openEndDrawer(),
            child: Scaffold(
              key: _scaffoldKey,
              body: content,
              endDrawer: const Drawer(width: 300, child: VyroxSidePanel()),
              bottomNavigationBar: NavigationBar(
                selectedIndex: index,
                onDestinationSelected: _select,
                destinations: _destinations
                    .map(
                      (_Destination d) => NavigationDestination(
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
          togglePanel: () => setState(() => _panelOpen = !_panelOpen),
          child: Scaffold(
            key: _scaffoldKey,
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: index,
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
                        (_Destination d) => NavigationRailDestination(
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

class VyroxSidePanel extends StatelessWidget {
  const VyroxSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final VyroxType type = VyroxType.of(context);
    final CreationsStore store = VyroxScope.of(context);
    final int total = store.items.length;
    final int running = store.items
        .where((Creation c) => c.status == CreationStatus.generating)
        .length;

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
            _PanelStat(label: 'Credits', value: '${store.credits}'),
            _PanelStat(label: 'Creations', value: '$total'),
            _PanelStat(label: 'Generating now', value: '$running'),
            const SizedBox(height: VyroxSpace.xl),
            Text('RECENT', style: type.label),
            const SizedBox(height: VyroxSpace.sm),
            if (total == 0)
              Text('Nothing yet — open Create to begin.', style: type.bodyMuted),
            for (final Creation c in store.items.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: VyroxSpace.xs),
                child: Row(
                  children: <Widget>[
                    Icon(c.type.icon, size: 16, color: VyroxColors.accent),
                    const SizedBox(width: VyroxSpace.sm),
                    Expanded(
                      child: Text(
                        c.prompt,
                        style: type.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
