import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onboarding/main.dart'; 

void main() {
  // This ensures the testing framework is fully initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Onboarding flow smoke test', (WidgetTester tester) async {
    // 1. Load the App
    await tester.pumpWidget(const KitchenApp());
    await tester.pumpAndSettle(); // Allow initial animations to finish

    // 2. Verify we are on the Streak/Home Screen
    // We check for the icon instead of text to avoid string mismatches
    expect(find.byIcon(Icons.settings), findsOneWidget);
    debugPrint('Successfully loaded landing screen');

    // 3. Trigger the transition
    await tester.tap(find.byIcon(Icons.settings));
    
    // 4. Wait for the navigation to Step 1
    // We use a longer timeout simulation if needed
    await tester.pumpAndSettle(); 

    // 5. Verify Step Header
    // Looking for the pattern "Step X of 12"
    final stepText = find.textContaining('Step 1');
    expect(stepText, findsOneWidget);
    
    final totalStepsText = find.textContaining('12');
    expect(totalStepsText, findsOneWidget);
    
    debugPrint('Successfully navigated to Step 1 of 12');
  });
}