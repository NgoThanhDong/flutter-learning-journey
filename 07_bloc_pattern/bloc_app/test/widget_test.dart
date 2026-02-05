import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_app/main.dart';

void main() {
  testWidgets('App loads and displays exercise list',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BlocApp());

    // Verify the app title is shown
    expect(find.text('Phase 7: BLoC Pattern'), findsOneWidget);
  });
}
