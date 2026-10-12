import 'package:flutter_test/flutter_test.dart';
import 'package:powervpn/main.dart';

void main() {
  testWidgets('PowerVPN app splash smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PowerVpnApp());
    expect(find.text('PowerVPN'), findsWidgets);

    // Advance animation and timer for splash screen navigation
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    expect(find.text('TAP TO CONNECT'), findsOneWidget);
  });
}
