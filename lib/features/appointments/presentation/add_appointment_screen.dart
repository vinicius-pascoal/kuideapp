import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../domain/appointment.dart';
import 'appointment_provider.dart';

class AddAppointmentScreen extends ConsumerStatefulWidget {
  const AddAppointmentScreen({super.key});
  @override
  ConsumerState<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends ConsumerState<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _clinic = TextEditingController();
  final _doctor = TextEditingController();
  var _type = AppointmentType.consultation;
  var _date = DateTime.now();
  var _time = TimeOfDay.now();
  var _reminder = '1 dia antes';

  @override
  void dispose() { _title.dispose(); _clinic.dispose(); _doctor.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(appointmentsProvider.notifier).add(Appointment(
      id: DateTime.now().microsecondsSinceEpoch.toString(), type: _type, title: _title.text.trim(), clinic: _clinic.text.trim(),
      doctor: _doctor.text.trim().isEmpty ? null : _doctor.text.trim(), reminder: _reminder,
      dateTime: DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute),
    ));
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, AppSpacing.lg),
          children: [
            Row(children: [IconButton.filled(onPressed: () => context.pop(), style: IconButton.styleFrom(backgroundColor: AppColors.wine, foregroundColor: AppColors.white), icon: const Icon(Icons.arrow_back, size: 18)), const SizedBox(width: 8), Text('Adicionar Compromisso', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.wine, fontWeight: FontWeight.w800))]),
            const SizedBox(height: 16),
            const _AppointmentLabel('Tipo de Compromisso'),
            Row(children: [
              _TypeChip(label: 'Consultas', selected: _type == AppointmentType.consultation, onTap: () => setState(() => _type = AppointmentType.consultation)),
              const SizedBox(width: 10),
              _TypeChip(label: 'Exames', selected: _type == AppointmentType.exam, onTap: () => setState(() => _type = AppointmentType.exam)),
              const SizedBox(width: 10),
              _TypeChip(label: 'Outros', selected: _type == AppointmentType.other, onTap: () => setState(() => _type = AppointmentType.other)),
            ]),
            const SizedBox(height: 12),
            const _AppointmentLabel('Nome ou Título'),
            _AppointmentTextField(controller: _title, hint: 'Ex: Consulta com Cardiologista', validator: _required('Informe o compromisso.')),
            const SizedBox(height: 10),
            const _AppointmentLabel('Local ou Clínica'),
            _AppointmentTextField(controller: _clinic, hint: 'Ex: Clínica Viva Mais', icon: Icons.location_on, validator: _required('Informe o local.')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const _AppointmentLabel('Data'), _DateTimeBox(value: _dateText, icon: Icons.calendar_today_outlined, onTap: _pickDate)])),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const _AppointmentLabel('Horário'), _DateTimeBox(value: _time.format(context), icon: Icons.access_time_outlined, onTap: _pickTime)])),
            ]),
            const SizedBox(height: 10),
            const _AppointmentLabel('Médico Responsável (opcional)'),
            _AppointmentTextField(controller: _doctor, hint: 'Ex: Dr. Roberto Silva'),
            const SizedBox(height: 10),
            const _AppointmentLabel('Avisar no Celular'),
            _ReminderChoices(value: _reminder, onChanged: (value) => setState(() => _reminder = value)),
            const SizedBox(height: 30),
            PrimaryButton(label: 'Salvar Compromisso', onPressed: _save),
          ],
        ),
      ),
    ),
  );

  String get _dateText => '${_date.day.toString().padLeft(2, '0')} / ${_date.month.toString().padLeft(2, '0')} / ${_date.year}';
  String? Function(String?) _required(String message) => (value) => value == null || value.trim().isEmpty ? message : null;
  Future<void> _pickDate() async { final value = await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: _date); if (value != null && mounted) setState(() => _date = value); }
  Future<void> _pickTime() async { final value = await showTimePicker(context: context, initialTime: _time); if (value != null && mounted) setState(() => _time = value); }
}

class _AppointmentLabel extends StatelessWidget { const _AppointmentLabel(this.text); final String text; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(text, style: const TextStyle(color: AppColors.wine, fontSize: 11, fontWeight: FontWeight.w800))); }

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label, required this.selected, required this.onTap}); final String label; final bool selected; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: selected ? AppColors.wine : AppColors.formField,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 30,
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: selected ? AppColors.white : AppColors.wineText),
            ),
          ),
        ),
      ),
    ),
  );
}

class _AppointmentTextField extends StatelessWidget {
  const _AppointmentTextField({required this.controller, this.hint, this.icon, this.validator}); final TextEditingController controller; final String? hint; final IconData? icon; final String? Function(String?)? validator;
  @override Widget build(BuildContext context) => TextFormField(controller: controller, validator: validator, style: const TextStyle(fontSize: 12, color: AppColors.wineText), decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(fontSize: 12, color: AppColors.wineText), prefixIcon: icon == null ? null : Icon(icon, size: 15, color: AppColors.wineText), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), isDense: true, border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none));
}

class _DateTimeBox extends StatelessWidget {
  const _DateTimeBox({required this.value, required this.icon, required this.onTap}); final String value; final IconData icon; final VoidCallback onTap;
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
              Icon(icon, size: 14, color: AppColors.wineText),
              const SizedBox(width: 7),
              Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: AppColors.wineText, fontWeight: FontWeight.w700))),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ReminderChoices extends StatelessWidget {
  const _ReminderChoices({required this.value, required this.onChanged}); final String value; final ValueChanged<String> onChanged;
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.fromLTRB(10, 9, 10, 8), decoration: BoxDecoration(color: AppColors.formField, borderRadius: BorderRadius.circular(10)), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ['1 dia antes', '2 horas antes', 'Na hora'].map((label) => InkWell(onTap: () => onChanged(label), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(value == label ? Icons.check_circle : Icons.radio_button_unchecked, size: 14, color: value == label ? AppColors.wine : AppColors.wineText), const SizedBox(width: 3), Text(label, style: const TextStyle(color: AppColors.wineText, fontSize: 9))]))).toList()), const SizedBox(height: 7), const Text('O app avisa no horário do lembrete', style: TextStyle(color: AppColors.wineText, fontSize: 8))]));
}
