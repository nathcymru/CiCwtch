import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/main.dart';

void main() {
  testWidgets('renders app shell with navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const CiCwtchApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    // IndexedStack renders all section screens simultaneously; each starts with
    // a loading indicator, so there are multiple CircularProgressIndicators.
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  });
}
