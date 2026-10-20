import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/app/app.dart';

void main() {
  testWidgets('exibe o shell principal', (tester) async {
    await tester.pumpWidget(const KuideApp());
    await tester.pumpAndSettle();

    expect(find.text('Início'), findsOneWidget);
    expect(find.text('HOME'), findsOneWidget);

    await tester.tap(find.text('SAÚDE'));
    await tester.pumpAndSettle();

    expect(find.text('Saúde'), findsOneWidget);
  });
}
