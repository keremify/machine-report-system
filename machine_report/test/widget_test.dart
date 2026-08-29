import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:machine_report/main.dart';
import 'package:machine_report/services/auth_service.dart';

void main() {
  tearDown(AuthService.instance.logout);

  testWidgets('shows login page when no user is signed in',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MachineReportApp());

    expect(find.text('Machine Report'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('administrator can log in and see reports list',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MachineReportApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'admin123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Failure Reports'), findsOneWidget);
    expect(find.text('New Failure'), findsOneWidget);
  });

  testWidgets('technician cannot create a new failure report',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MachineReportApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'tech');
    await tester.enterText(find.byType(TextFormField).at(1), 'tech123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Failure Reports'), findsOneWidget);
    expect(find.text('New Failure'), findsNothing);
  });

  testWidgets('invalid credentials show an error message',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MachineReportApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid username or password.'), findsOneWidget);
  });
}