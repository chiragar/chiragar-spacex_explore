import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chiragar_spacex_explore/main.dart' as app; // Import your main.dart
import 'package:chiragar_spacex_explore/presentation/widgets/launch_list_item.dart';
import 'package:chiragar_spacex_explore/presentation/pages/launch_details_page.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Tap on a launch item and navigate to details', (WidgetTester tester) async {
    app.main(); // Start the app
    await tester.pumpAndSettle(const Duration(seconds: 5)); // Wait for initial load

    // Verify that launch items are displayed
    expect(find.byType(LaunchListItem), findsWidgets);

    // Find the first launch item and tap it
    final firstLaunchItem = find.byType(LaunchListItem).first;
    await tester.tap(firstLaunchItem);
    await tester.pumpAndSettle(const Duration(seconds: 3)); // Wait for navigation and details load

    // Verify that we are on the LaunchDetailsPage
    expect(find.byType(LaunchDetailsPage), findsOneWidget);
    // You can add more specific checks for content on the details page
    expect(find.textContaining('Details'), findsWidgets); // Assuming 'Details' section title
  });
}