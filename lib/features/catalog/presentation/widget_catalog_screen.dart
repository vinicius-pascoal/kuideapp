import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_list_tile.dart';
import '../../../shared/widgets/filter_tab_bar.dart';
import '../../../shared/widgets/mock_action_dialog.dart';

class WidgetCatalogScreen extends StatefulWidget {
  const WidgetCatalogScreen({super.key});

  @override
  State<WidgetCatalogScreen> createState() => _WidgetCatalogScreenState();
}

class _WidgetCatalogScreenState extends State<WidgetCatalogScreen> {
  var _selectedFilter = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppHeader(
            title: 'Catálogo de widgets',
            onBack: () => Navigator.maybePop(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Ações'),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Ação principal',
            icon: Icons.check,
            onPressed: () => MockActionDialog.show(
              context,
              title: 'Ação simulada',
              message: 'Este diálogo é uma prévia de componente.',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(label: 'Ação secundária', onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          DangerButton(label: 'Ação de risco', onPressed: () {}),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Campos'),
          const SizedBox(height: AppSpacing.sm),
          AppSearchField(onChanged: (_) {}),
          const SizedBox(height: AppSpacing.sm),
          const AppTextField(label: 'Nome completo', hint: 'Digite aqui'),
          const SizedBox(height: AppSpacing.sm),
          const AppPasswordField(label: 'Senha'),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Seleção e status'),
          const SizedBox(height: AppSpacing.sm),
          FilterTabBar(
            labels: const ['Todos', 'Pendentes', 'Concluídos'],
            selectedIndex: _selectedFilter,
            onSelected: (index) => setState(() => _selectedFilter = index),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Wrap(
            spacing: AppSpacing.xs,
            children: [
              StatusChip(label: 'Tomado', color: AppColors.success),
              StatusChip(label: 'Pendente', color: AppColors.wine),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Card e lista'),
          const SizedBox(height: AppSpacing.sm),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Losartana 50 mg'),
                SizedBox(height: AppSpacing.xs),
                Text('1 comprimido • Tomar com água'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppListTile(
            title: 'Consulta com cardiologista',
            subtitle: 'Dr. Roberto Silva • Clínica Vida',
            leading: Icon(Icons.calendar_month_outlined),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    ),
  );
}
