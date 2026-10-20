import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import '../domain/medication.dart';
import 'medication_provider.dart';

class AddMedicationScreen extends ConsumerStatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  ConsumerState<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _periodController = TextEditingController(text: 'Uso contínuo');
  final _stockController = TextEditingController(text: '30');
  final _alertController = TextEditingController(text: '10');
  var _form = 'Comprimido';
  var _recurrence = 'Diariamente';
  var _time = '';

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _periodController.dispose();
    _stockController.dispose();
    _alertController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_time.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe o horário.')));
      return;
    }
    final stock = int.tryParse(_stockController.text) ?? 0;
    final alert = int.tryParse(_alertController.text) ?? 0;
    await ref.read(medicationsProvider.notifier).add(
          Medication(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: _nameController.text.trim(),
            dosage: _dosageController.text.trim(),
            form: _form,
            period: _periodController.text.trim(),
            time: _time,
            recurrence: _recurrence,
            stock: stock,
            lowStockAlertAt: alert,
          ),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                AppHeader(title: 'Novo medicamento', onBack: () => context.pop()),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(label: 'Nome', controller: _nameController, validator: _required('Informe o nome do medicamento.')),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Dosagem', controller: _dosageController, validator: _required('Informe a dosagem.')),
                const SizedBox(height: AppSpacing.sm),
                AppDropdown<String>(
                  label: 'Formato',
                  value: _form,
                  onChanged: (value) => setState(() => _form = value ?? _form),
                  items: const [DropdownMenuItem(value: 'Comprimido', child: Text('Comprimido')), DropdownMenuItem(value: 'Gotas', child: Text('Gotas')), DropdownMenuItem(value: 'Cápsula', child: Text('Cápsula'))],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Período de uso', controller: _periodController, validator: _required('Informe o período de uso.')),
                const SizedBox(height: AppSpacing.sm),
                AppTimeField(label: 'Horário', value: _time.isEmpty ? 'Selecionar horário' : _time, onTap: _pickTime),
                const SizedBox(height: AppSpacing.sm),
                AppDropdown<String>(
                  label: 'Recorrência',
                  value: _recurrence,
                  onChanged: (value) => setState(() => _recurrence = value ?? _recurrence),
                  items: const [DropdownMenuItem(value: 'Diariamente', child: Text('Diariamente')), DropdownMenuItem(value: 'Em dias alternados', child: Text('Em dias alternados'))],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Estoque atual', controller: _stockController, keyboardType: TextInputType.number, validator: _nonNegative('Informe um estoque válido.')),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Alerta de estoque baixo', controller: _alertController, keyboardType: TextInputType.number, validator: _nonNegative('Informe um alerta válido.')),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(label: 'Salvar medicamento', onPressed: _save),
              ],
            ),
          ),
        ),
      );

  String? Function(String?) _required(String message) => (value) => value == null || value.trim().isEmpty ? message : null;

  String? Function(String?) _nonNegative(String message) => (value) {
        final number = int.tryParse(value ?? '');
        return number == null || number < 0 ? message : null;
      };

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && mounted) setState(() => _time = picked.format(context));
  }
}
