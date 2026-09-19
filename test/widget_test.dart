import 'package:flutter_test/flutter_test.dart';
import 'package:versos_diarios/main.dart';

void main() {
  testWidgets('App inicia na SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const VersosDiariosApp());

    expect(find.text('Versos Diários'), findsOneWidget);
  });
}
