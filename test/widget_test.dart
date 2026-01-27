// This is a basic Flutter widget test for WakyGut.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('WakyGut basic test', (WidgetTester tester) async {
    // Build a simple test widget
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('WakyGut'),
            ),
          ),
        ),
      ),
    );

    // Verify the app name is displayed
    expect(find.text('WakyGut'), findsOneWidget);
  });
}
