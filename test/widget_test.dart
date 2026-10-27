import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';

void main() {
  testWidgets('empty form shows all three errors', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('valid form shows the success message', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField).at(0), 'Sam');
    await tester.enterText(find.byType(TextFormField).at(1), 'sam@test.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.textContaining('Demo signup complete'), findsOneWidget);
  });

  testWidgets('tip shows a preset tip with its label', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Get a signup tip'));
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Preset demo tip—not live AI.'), findsOneWidget);
  });

  testWidgets('tip error shows retry and then recovers', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.byType(Switch));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Retry'), findsOneWidget);

    // Turn the error off, then retry.
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Preset demo tip—not live AI.'), findsOneWidget);
  });
}
