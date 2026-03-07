import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/main.dart';

void main() {
  testWidgets('renders dashboard home page', (WidgetTester tester) async {
    await tester.pumpWidget(const CiCwtchApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
