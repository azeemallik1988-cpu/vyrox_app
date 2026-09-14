import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyrox_app/app/app.dart';
import 'package:vyrox_app/core/models/creation.dart';
import 'package:vyrox_app/core/state/creations_notifier.dart';

Future<void> _pumpApp(
  WidgetTester tester, {
  required Size size,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const VyroxApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('NavigationBar has 5 destinations on phone', (tester) async {
    await _pumpApp(tester, size: const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    final labels = bar.destinations
        .map((d) => (d as NavigationDestination).label)
        .toList();
    expect(labels, ['Home', 'Create', 'Explore', 'Creations', 'Profile']);
  });

  testWidgets('NavigationRail on wide layout', (tester) async {
    await _pumpApp(tester, size: const Size(1200, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    final labels = rail.destinations.map((d) => (d.label as Text).data).toList();
    expect(labels, ['Home', 'Create', 'Explore', 'Creations', 'Profile']);
  });

  testWidgets('adding a Creation shows on Creations screen', (tester) async {
    await _pumpApp(tester, size: const Size(390, 844));

    final context = tester.element(find.byType(VyroxApp));
    final container = ProviderScope.containerOf(context);
    container.read(creationsProvider.notifier).add(
          Creation(
            id: 'test-1',
            type: CreationType.image,
            prompt: 'Neon city test',
            status: CreationStatus.done,
            createdAt: DateTime.now(),
            thumbnailSeed: 42,
          ),
        );

    await tester.tap(find.text('Creations'));
    await tester.pumpAndSettle();

    expect(find.text('Neon city test'), findsWidgets);
  });
}
