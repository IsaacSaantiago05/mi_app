// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mi_app/main.dart';

void main() {
  testWidgets('Load registration screen', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the registration screen is shown.
    expect(find.text('Registro de usuario'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
  });
}
