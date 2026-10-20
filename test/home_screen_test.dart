import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/app/theme/app_theme.dart';
import 'package:kuideapp/features/home/presentation/home_screen.dart';
import 'package:kuideapp/features/home/presentation/quick_access_screen.dart';

Widget _host(Widget child) => ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: child),
    );

void main() {
  testWidgets('Home apresenta os seis atalhos principais', (tester) async {
    await tester.pumpWidget(_host(const HomeScreen()));

    expect(find.text('Medicamentos'), findsOneWidget);
    expect(find.text('Compromissos'), findsOneWidget);
    expect(find.text('Saúde'), findsOneWidget);
    expect(find.text('Compras'), findsOneWidget);
    expect(find.text('Tarefas'), findsOneWidget);
    expect(find.text('Contatos'), findsOneWidget);
  });

  testWidgets('Acesso rápido filtra atalhos por texto', (tester) async {
    await tester.pumpWidget(_host(const QuickAccessScreen()));

    await tester.enterText(find.byType(TextField), 'compras');
    await tester.pump();

    expect(find.text('Compras'), findsOneWidget);
    expect(find.text('Medicamentos'), findsNothing);
  });
}
