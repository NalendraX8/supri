import 'package:flutter_test/flutter_test.dart';

import 'package:supri/main.dart';

void main() {
  testWidgets('SupriApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SupriApp());

    // Wait for any async operations
    await tester.pump();

    // Verify that the app title is displayed
    expect(find.text('Examples'), findsOneWidget);
  });
}
