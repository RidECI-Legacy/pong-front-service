import 'package:flutter_test/flutter_test.dart';

import 'package:rideeci/main.dart';

void main() {
  testWidgets('Landing screen shows hero heading', (WidgetTester tester) async {
    await tester.pumpWidget(const RideEciApp());
    await tester.pumpAndSettle();

    expect(find.text('RidECI'), findsOneWidget);
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
  });
}
