import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personal_money_tracker/widgets/dashboard_card.dart';

void main() {
  testWidgets('dashboard card shows rupee totals', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DashboardCard(todayTotal: 1250))),
    );

    expect(find.text("Today's spending"), findsOneWidget);
    expect(find.text('₹1,250'), findsOneWidget);
  });
}
