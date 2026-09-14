import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyrox_app/core/store.dart';
import 'package:vyrox_app/main.dart';
import 'package:vyrox_app/screens/creations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    vyroxTab.value = 0;
  });

  Widget app(CreationsStore store) =>
      VyroxScope(store: store, child: const VyroxApp());

  testWidgets('phone layout shows bottom bar with 5 tabs', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(app(CreationsStore()));
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    for (final String label in <String>[
      'Home',
      'Create',
      'Explore',
      'Creations',
      'Profile',
    ]) {
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('wide layout shows navigation rail', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(app(CreationsStore()));
    await tester.pump();

    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('added creation appears in Creations screen', (tester) async {
    final CreationsStore store = CreationsStore()
      ..add(
        Creation(
          id: 'test-1',
          type: CreationType.image,
          prompt: 'Test prompt',
          status: CreationStatus.done,
          createdAt: DateTime(2024),
          thumbnailSeed: 42,
        ),
      );

    await tester.pumpWidget(
      VyroxScope(
        store: store,
        child: const MaterialApp(home: Scaffold(body: CreationsScreen())),
      ),
    );
    await tester.pump();

    expect(find.byType(CreationThumb), findsOneWidget);
  });
}
