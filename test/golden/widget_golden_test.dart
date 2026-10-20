import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/app/theme/app_theme.dart';
import 'package:kuideapp/shared/widgets/app_card.dart';
import 'package:kuideapp/shared/widgets/app_bottom_nav_bar.dart';

void main() {
  testWidgets(
    'baseline visual de AppCard',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: Center(child: AppCard(child: Text('Losartana 50 mg')))),
        ),
      );

      await expectLater(find.byType(AppCard), matchesGoldenFile('goldens/app_card.png'));
    },
    skip: 'Gerar baseline com flutter test --update-goldens quando o SDK estiver disponível.',
  );

  testWidgets(
    'baseline visual de AppBottomNavBar',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: 0,
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(AppBottomNavBar),
        matchesGoldenFile('goldens/app_bottom_nav_bar.png'),
      );
    },
    skip: 'Gerar baseline com flutter test --update-goldens quando o SDK estiver disponível.',
  );
}
