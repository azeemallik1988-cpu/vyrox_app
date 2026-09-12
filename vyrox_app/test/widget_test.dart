import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyrox_app/main.dart';

void main() {
  testWidgets('VYROX home screen loads', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(const VyroxApp());
    await tester.pumpAndSettle();
    expect(find.text('VYROX AI'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
