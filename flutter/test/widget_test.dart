import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/main.dart';

void main() {
  testWidgets('renders starter home page', (WidgetTester tester) async {
    await tester.pumpWidget(const CiCwtchApp());

    expect(find.text('CiCwtch'), findsOneWidget);
    expect(find.text('CiCwtch Flutter starter is ready.'), findsOneWidget);
  });
}
