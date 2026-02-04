import 'package:flutter_test/flutter_test.dart';
import 'package:clean_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const CleanArchitectureApp());
    expect(find.text('Phase 6: Clean Architecture'), findsOneWidget);
  });
}
