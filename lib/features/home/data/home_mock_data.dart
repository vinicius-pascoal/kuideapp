import 'package:flutter/material.dart';

import '../domain/quick_access_item.dart';

abstract final class HomeMockData {
  static const quickAccess = [
    QuickAccessItem(label: 'Medicamentos', description: 'Lembretes e doses', icon: Icons.medication_outlined, route: '/medications'),
    QuickAccessItem(label: 'Compromissos', description: 'Consultas e exames', icon: Icons.calendar_month_outlined, route: '/appointments'),
    QuickAccessItem(label: 'Saúde', description: 'Pressão, peso e mais', icon: Icons.favorite_outline, route: '/health'),
    QuickAccessItem(label: 'Compras', description: 'Sua lista de compras', icon: Icons.shopping_cart_outlined, route: '/shopping'),
    QuickAccessItem(label: 'Tarefas', description: 'O que fazer hoje', icon: Icons.check_circle_outline, route: '/tasks'),
    QuickAccessItem(label: 'Contatos', description: 'Pessoas importantes', icon: Icons.people_outline, route: '/contacts'),
  ];

  static const expandedQuickAccess = [
    ...quickAccess,
    QuickAccessItem(label: 'Rotina', description: 'Veja o seu dia', icon: Icons.today_outlined, route: '/routine'),
    QuickAccessItem(label: 'Emergência', description: 'Contatos e ficha de saúde', icon: Icons.sos_outlined, route: '/emergency'),
  ];
}
