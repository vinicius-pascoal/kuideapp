import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import '../domain/appointment.dart';
import 'appointment_provider.dart';

class AddAppointmentScreen extends ConsumerStatefulWidget { const AddAppointmentScreen({super.key}); @override ConsumerState<AddAppointmentScreen> createState() => _AddAppointmentScreenState(); }
class _AddAppointmentScreenState extends ConsumerState<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>(); final _title = TextEditingController(); final _clinic = TextEditingController(); final _doctor = TextEditingController(); var _type = AppointmentType.consultation; var _date = DateTime.now(); var _time = TimeOfDay.now(); var _reminder = '1 dia antes';
  @override void dispose() { _title.dispose(); _clinic.dispose(); _doctor.dispose(); super.dispose(); }
  Future<void> _save() async { if (!_formKey.currentState!.validate()) return; ref.read(appointmentsProvider.notifier).add(Appointment(id: DateTime.now().microsecondsSinceEpoch.toString(), type: _type, title: _title.text.trim(), clinic: _clinic.text.trim(), doctor: _doctor.text.trim().isEmpty ? null : _doctor.text.trim(), reminder: _reminder, dateTime: DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute))); context.pop(); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
    AppHeader(title: 'Novo compromisso', onBack: () => context.pop()), const SizedBox(height: AppSpacing.lg),
    AppDropdown<AppointmentType>(label: 'Tipo', value: _type, onChanged: (value) => setState(() => _type = value ?? _type), items: AppointmentType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.label))).toList()), const SizedBox(height: AppSpacing.sm),
    AppTextField(label: 'Nome', controller: _title, validator: _required('Informe o compromisso.')), const SizedBox(height: AppSpacing.sm), AppTextField(label: 'Clínica ou local', controller: _clinic, validator: _required('Informe o local.')), const SizedBox(height: AppSpacing.sm), AppTextField(label: 'Médico (opcional)', controller: _doctor), const SizedBox(height: AppSpacing.sm),
    AppDateField(label: 'Data', value: '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}', onTap: _pickDate), const SizedBox(height: AppSpacing.sm), AppTimeField(label: 'Horário', value: _time.format(context), onTap: _pickTime), const SizedBox(height: AppSpacing.sm),
    AppDropdown<String>(label: 'Aviso visual', value: _reminder, onChanged: (value) => setState(() => _reminder = value ?? _reminder), items: const [DropdownMenuItem(value: '1 dia antes', child: Text('1 dia antes')), DropdownMenuItem(value: '2 horas antes', child: Text('2 horas antes')), DropdownMenuItem(value: 'Sem aviso', child: Text('Sem aviso'))]), const SizedBox(height: AppSpacing.xl), PrimaryButton(label: 'Salvar compromisso', onPressed: _save),
  ]))));
  String? Function(String?) _required(String message) => (value) => value == null || value.trim().isEmpty ? message : null;
  Future<void> _pickDate() async { final value = await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: _date); if (value != null) setState(() => _date = value); }
  Future<void> _pickTime() async { final value = await showTimePicker(context: context, initialTime: _time); if (value != null) setState(() => _time = value); }
}
