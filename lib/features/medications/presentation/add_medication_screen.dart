import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
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
  final _dosageController = TextEditingController(text: '1 Comprimido');
  final _stockController = TextEditingController(text: '30');
  var _form = 'Comprimido';
  var _recurrence = 'Uma vez ao dia';
  var _period = 'Manhã';
  var _time = '08:00';

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(medicationsProvider.notifier).add(
          Medication(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: _nameController.text.trim(), dosage: _dosageController.text.trim(), form: _form, period: _period, time: _time,
            recurrence: _recurrence, stock: int.tryParse(_stockController.text) ?? 0, lowStockAlertAt: 5,
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
          padding: const EdgeInsets.fromLTRB(18, 18, 18, AppSpacing.lg),
          children: [
            Row(children: [
              IconButton.filled(onPressed: () => context.pop(), style: IconButton.styleFrom(backgroundColor: AppColors.wine, foregroundColor: AppColors.white), icon: const Icon(Icons.arrow_back, size: 18)),
              const SizedBox(width: 8),
              Text('Adicionar Medicamento', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.wine, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 16),
            const _FieldLabel('Nome do Remédio'),
            _CompactTextField(controller: _nameController, hint: 'Ex: Losartana 50mg', validator: _required('Informe o nome do medicamento.')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const _FieldLabel('Dosagem por vez'), _CompactTextField(controller: _dosageController, validator: _required('Informe a dosagem.'))])),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const _FieldLabel('Tipo / Formato'), _CompactSelector(value: _form, onTap: _cycleForm)])),
            ]),
            const SizedBox(height: 12),
            const _FieldLabel('Período de Tomada'),
            Row(children: ['Manhã', 'Tarde', 'Noite'].map((period) => Expanded(child: Padding(padding: EdgeInsets.only(right: period == 'Noite' ? 0 : 8), child: _PeriodOption(label: period, selected: _period == period, onTap: () => setState(() => _period = period))))).toList()),
            const SizedBox(height: 12),
            const _FieldLabel('Horário do Lembrete'),
            _CompactSelector(value: _time, icon: Icons.access_time_outlined, onTap: _pickTime),
            const SizedBox(height: 12),
            const _FieldLabel('Recorrência do medicamento'),
            _CompactSelector(value: _recurrence, onTap: _cycleRecurrence),
            const SizedBox(height: 12),
            const _FieldLabel('Avisar sobre estoque baixo'),
            _StockAlert(controller: _stockController),
            const SizedBox(height: 30),
            PrimaryButton(label: 'Salvar Medicamento', onPressed: _save),
          ],
        ),
      ),
    ),
  );

  void _cycleForm() {
    const forms = ['Comprimido', 'Cápsula', 'Gotas'];
    setState(() => _form = forms[(forms.indexOf(_form) + 1) % forms.length]);
  }

  void _cycleRecurrence() {
    const recurrences = ['Uma vez ao dia', 'A cada 12 horas', 'Em dias alternados'];
    setState(() => _recurrence = recurrences[(recurrences.indexOf(_recurrence) + 1) % recurrences.length]);
  }

  Future<void> _pickTime() async {
    final parts = _time.split(':');
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay(hour: int.parse(parts.first), minute: int.parse(parts.last)));
    if (picked != null && mounted) setState(() => _time = picked.format(context));
  }

  String? Function(String?) _required(String message) => (value) => value == null || value.trim().isEmpty ? message : null;
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(label, style: const TextStyle(color: AppColors.wine, fontSize: 11, fontWeight: FontWeight.w800)));
}

class _CompactTextField extends StatelessWidget {
  const _CompactTextField({required this.controller, this.hint, this.validator});
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller, validator: validator, style: const TextStyle(fontSize: 12, color: AppColors.wineText),
    decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(fontSize: 12, color: AppColors.wineText), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), isDense: true, border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
  );
}

class _CompactSelector extends StatelessWidget {
  const _CompactSelector({required this.value, required this.onTap, this.icon});
  final String value;
  final VoidCallback onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.formField,
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: AppColors.wineText),
                const SizedBox(width: 7),
              ],
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(color: AppColors.wineText, fontSize: 12),
                ),
              ),
              const Icon(Icons.chevron_right, size: 15, color: AppColors.wineText),
            ],
          ),
        ),
      ),
    ),
  );
}

class _PeriodOption extends StatelessWidget {
  const _PeriodOption({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: selected ? AppColors.wine : AppColors.formField, borderRadius: BorderRadius.circular(18), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: SizedBox(height: 34, child: Center(child: Text(label, style: TextStyle(color: selected ? AppColors.white : AppColors.wineText, fontSize: 10, fontWeight: FontWeight.w700))))));
}

class _StockAlert extends StatelessWidget {
  const _StockAlert({required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 9, 10, 8), decoration: BoxDecoration(color: AppColors.formField, borderRadius: BorderRadius.circular(10)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Expanded(child: Text('Quantidade atual de comprimidos:', style: TextStyle(color: AppColors.wine, fontSize: 10, fontWeight: FontWeight.w800))), SizedBox(width: 38, height: 21, child: TextFormField(controller: controller, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w700), decoration: InputDecoration(isDense: true, filled: true, fillColor: AppColors.wine, contentPadding: EdgeInsets.zero, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))))]),
      const SizedBox(height: 5), const Text('O app avisa quando faltarem menos de 5 comprimidos.', style: TextStyle(color: AppColors.wineText, fontSize: 8)),
    ]),
  );
}
