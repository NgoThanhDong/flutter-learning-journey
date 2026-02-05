import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_app/main.dart'; // Import BlocPatternApp

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BlocPatternApp());

    // Verify that the title is present
    expect(find.text('Phase 7: BLoC Pattern'), findsOneWidget);
  });
}
