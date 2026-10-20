import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuideapp/app/app.dart';

void main() {
  testWidgets('a splash leva ao login', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: KuideApp()));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vinda ao KUIDE'), findsOneWidget);
  });
}
