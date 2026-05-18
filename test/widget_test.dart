import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:forge_routine/main.dart';

void main() {
  testWidgets('Counter initial state test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ForgeRoutineApp()));

    // Verify that our placeholder text is present.
    expect(find.textContaining('ForgeRoutine'), findsOneWidget);
  });
}
