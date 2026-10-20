import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/app/theme/app_theme.dart';
import 'package:kuideapp/shared/widgets/app_buttons.dart';
import 'package:kuideapp/shared/widgets/app_card.dart';
import 'package:kuideapp/shared/widgets/filter_tab_bar.dart';

Widget _host(Widget child) => MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

void main() {
  testWidgets('PrimaryButton respeita estado desabilitado e loading', (tester) async {
    await tester.pumpWidget(_host(const PrimaryButton(label: 'Salvar', onPressed: null)));

    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);

    await tester.pumpWidget(_host(const PrimaryButton(label: 'Salvar', onPressed: null, isLoading: true)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('FilterTabBar comunica a alteração de seleção', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) => FilterTabBar(
            labels: const ['Todos', 'Pendentes'],
            selectedIndex: selected,
            onSelected: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pendentes'));
    await tester.pump();

    expect(tester.widget<ChoiceChip>(find.byType(ChoiceChip).at(1)).selected, isTrue);
  });

  testWidgets('AppCard expõe conteúdo e toque', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _host(AppCard(onTap: () => tapped = true, child: const Text('Conteúdo do card'))),
    );

    await tester.tap(find.text('Conteúdo do card'));

    expect(tapped, isTrue);
  });
}
