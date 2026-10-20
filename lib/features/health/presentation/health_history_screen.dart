import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/mock_action_dialog.dart';
import '../domain/health_measurement.dart';
import 'health_provider.dart';

class HealthHistoryScreen extends ConsumerStatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  ConsumerState<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends ConsumerState<HealthHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: HealthMetric.values.length, vsync: this)..addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final metric = HealthMetric.values[_tabController.index];
    final measurements = ref.watch(healthMeasurementsProvider)
        .where((measurement) => measurement.metric == metric)
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Text('Histórico de saúde', style: Theme.of(context).textTheme.headlineSmall),
            ),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.wine,
              tabs: HealthMetric.values.map((item) => Tab(text: item.label)).toList(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  if (measurements.isNotEmpty) _CurrentMeasurementCard(measurement: measurements.first),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Histórico anterior', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  for (final measurement in measurements.skip(1)) _MeasurementTile(measurement: measurement),
                  if (measurements.length <= 1) const Text('Ainda não há registros anteriores.'),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(label: 'Adicionar registro', icon: Icons.add, onPressed: () => _openAddMeasurement(metric)),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    label: 'Enviar histórico ao médico',
                    icon: Icons.send_outlined,
                    onPressed: () => MockActionDialog.show(
                      context,
                      title: 'Prévia simulada',
                      message: 'Nenhum dado de saúde será enviado. Esta ação mostra apenas uma prévia local.',
                      confirmLabel: 'Entendi',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddMeasurement(HealthMetric metric) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => _MeasurementForm(metric: metric),
      );
}

class _CurrentMeasurementCard extends StatelessWidget {
  const _CurrentMeasurementCard({required this.measurement});

  final HealthMeasurement measurement;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Registro atual', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('${measurement.value} ${measurement.metric.unit}', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 28)),
            Text(_dateLabel(measurement.recordedAt)),
          ],
        ),
      );
}

class _MeasurementTile extends StatelessWidget {
  const _MeasurementTile({required this.measurement});

  final HealthMeasurement measurement;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: AppCard(
          tint: false,
          child: Row(
            children: [
              const Icon(Icons.monitor_heart_outlined, color: AppColors.wine),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text('${measurement.value} ${measurement.metric.unit}')),
              Text(_dateLabel(measurement.recordedAt)),
            ],
          ),
        ),
      );
}

class _MeasurementForm extends ConsumerStatefulWidget {
  const _MeasurementForm({required this.metric});

  final HealthMetric metric;

  @override
  ConsumerState<_MeasurementForm> createState() => _MeasurementFormState();
}

class _MeasurementFormState extends ConsumerState<_MeasurementForm> {
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Novo registro de ${widget.metric.label}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Valor (${widget.metric.unit})',
              hint: widget.metric == HealthMetric.pressure ? 'Ex.: 120/80' : 'Ex.: 98',
              controller: _valueController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Salvar registro',
              onPressed: () {
                final value = _valueController.text.trim();
                if (value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe o valor medido.')));
                  return;
                }
                ref.read(healthMeasurementsProvider.notifier).add(metric: widget.metric, value: value);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}

String _dateLabel(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
