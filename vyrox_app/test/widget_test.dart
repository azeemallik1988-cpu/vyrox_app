import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyrox_app/main.dart';

void main() {
  testWidgets('VYROX shell loads on phone layout', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const VyroxApp());
    await tester.pump();

    expect(find.byType(VyroxShell), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('VYROX shell loads on wide layout', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const VyroxApp());
    await tester.pump();

    expect(find.byType(VyroxShell), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
  });
}
