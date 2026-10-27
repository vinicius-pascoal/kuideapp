import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_header.dart';

class PrescriptionDemoScreen extends StatelessWidget {
  const PrescriptionDemoScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppHeader(title: 'Receita médica', onBack: () => context.pop()),
          const SizedBox(height: AppSpacing.md),
          const _DemoNotice(),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('RECEITA MÉDICA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.wine))),
                SizedBox(height: 24),
                Text('Dra. Helena Ribeiro', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                Text('Clínica Geral • CRM 000000/BR'),
                Divider(height: 30),
                Text('Paciente: Maria Santos', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 18),
                _PrescriptionItem(number: '1', name: 'Losartana 50 mg', instruction: 'Tomar 1 comprimido pela manhã.'),
                SizedBox(height: 16),
                _PrescriptionItem(number: '2', name: 'Vitamina D 2.000 UI', instruction: 'Tomar 1 cápsula após o almoço.'),
                SizedBox(height: 34),
                Align(alignment: Alignment.centerRight, child: Text('São Paulo, 27/10/2026')),
                SizedBox(height: 38),
                Center(child: Text('Documento fictício para demonstração', style: TextStyle(color: AppColors.wineText, fontWeight: FontWeight.w700))),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.cardTint, borderRadius: BorderRadius.circular(12)),
    child: const Row(children: [Icon(Icons.info_outline, color: AppColors.wine), SizedBox(width: 10), Expanded(child: Text('Este documento é fictício e não tem validade médica.'))]),
  );
}

class _PrescriptionItem extends StatelessWidget {
  const _PrescriptionItem({required this.number, required this.name, required this.instruction});

  final String number;
  final String name;
  final String instruction;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text('$number.', style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w700)), Text(instruction)]))],
  );
}
