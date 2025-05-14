import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_spacex_explore/presentation/widgets/launch_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Mock this if needed or provide fallback

void main() {
  final tLaunch = Launch(
    id: '123',
    missionName: 'Starlink v1.0 L22',
    launchDateUtc: DateTime.parse("2021-03-24T07:28:00.000Z"),
    rocketName: 'Falcon 9',
    rocketType: 'FT',
    launchSuccess: true,
    missionPatchSmall: 'https://images2.imgbox.com/02/51/7NLaBm8c_o.png',
  );

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('LaunchListItem displays mission name, rocket, date, and status', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(LaunchListItem(launch: tLaunch)));

    // Allow time for CachedNetworkImage to settle (or mock it)
    await tester.pumpAndSettle();


    expect(find.text('Starlink v1.0 L22'), findsOneWidget);
    expect(find.text('Rocket: Falcon 9'), findsOneWidget);
    expect(find.textContaining('Mar 24, 2021'), findsOneWidget); // Check date format
    expect(find.text('Status: Success'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}