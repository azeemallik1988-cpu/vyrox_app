import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyrox_app/main.dart';

void main() {
  testWidgets('VYROX home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const VyroxApp());
    await tester.pump();
    expect(find.textContaining('VYROX'), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
