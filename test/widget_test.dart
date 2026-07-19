import 'package:flutter_test/flutter_test.dart';
import 'package:supri/injection_container.dart' as di;
import 'package:supri/main.dart';

void main() {
  setUp(() async {
    // Initialize dependencies
    await di.initDependencies();
  });

  tearDown(() async {
    // Reset GetIt after each test
    await di.sl.reset();
  });

  testWidgets('SupriApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SupriApp());

    // Wait for any async operations
    await tester.pump();

    // Verify that the login button is displayed
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
