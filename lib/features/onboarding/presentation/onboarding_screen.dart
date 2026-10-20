import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import 'onboarding_provider.dart';

enum OnboardingStep { medicines, doctor, emergency }

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({required this.step, super.key});

  final OnboardingStep step;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _firstController = TextEditingController();
  final _secondController = TextEditingController();
  final _thirdController = TextEditingController();
  String? _bloodType;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider);
    switch (widget.step) {
      case OnboardingStep.doctor:
        _firstController.text = draft.primaryDoctor;
        _secondController.text = draft.nextAppointment;
      case OnboardingStep.emergency:
        _bloodType = draft.bloodType.isEmpty ? null : draft.bloodType;
        _secondController.text = draft.allergies;
        _thirdController.text = draft.familyContact;
      case OnboardingStep.medicines:
        break;
    }
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    super.dispose();
  }

  int get _stepNumber => widget.step.index + 1;

  void _goTo(OnboardingStep step) {
    final path = switch (step) {
      OnboardingStep.medicines => '/onboarding/medicines',
      OnboardingStep.doctor => '/onboarding/doctor',
      OnboardingStep.emergency => '/onboarding/emergency',
    };
    context.go(path);
  }

  Future<void> _continue() async {
    switch (widget.step) {
      case OnboardingStep.medicines:
        _goTo(OnboardingStep.doctor);
        return;
      case OnboardingStep.doctor:
        await ref.read(onboardingProvider.notifier).saveDoctorDetails(
              doctor: _firstController.text.trim(),
              appointment: _secondController.text.trim(),
            );
        if (mounted) _goTo(OnboardingStep.emergency);
        return;
      case OnboardingStep.emergency:
        await ref.read(onboardingProvider.notifier).saveEmergencyDetails(
              bloodType: _bloodType ?? '',
              allergies: _secondController.text.trim(),
              familyContact: _thirdController.text.trim(),
              completed: true,
            );
        if (mounted) context.go('/home');
        return;
    }
  }

  Future<void> _fillLater() async {
    if (widget.step == OnboardingStep.emergency) {
      await ref.read(onboardingProvider.notifier).saveEmergencyDetails(
            bloodType: _bloodType ?? '',
            allergies: _secondController.text.trim(),
            familyContact: _thirdController.text.trim(),
            completed: true,
          );
      if (mounted) context.go('/home');
      return;
    }
    await _continue();
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (widget.step) {
      OnboardingStep.medicines => 'Seus remédios',
      OnboardingStep.doctor => 'Médico e consulta',
      OnboardingStep.emergency => 'Para emergências',
    };
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppHeader(onBack: _stepNumber == 1 ? () => context.go('/login') : _back, title: title),
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  label: 'Etapa $_stepNumber de 3',
                  child: LinearProgressIndicator(value: _stepNumber / 3),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('Passo $_stepNumber de 3', textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.xl),
                _stepContent(),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(label: _stepNumber == 3 ? 'Concluir' : 'Continuar', onPressed: _continue),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(label: 'Preencher depois', onPressed: _fillLater),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _back() {
    switch (widget.step) {
      case OnboardingStep.medicines:
        context.go('/login');
        return;
      case OnboardingStep.doctor:
        _goTo(OnboardingStep.medicines);
        return;
      case OnboardingStep.emergency:
        _goTo(OnboardingStep.doctor);
        return;
    }
  }

  Widget _stepContent() => switch (widget.step) {
        OnboardingStep.medicines => _medicinesContent(),
        OnboardingStep.doctor => _doctorContent(),
        OnboardingStep.emergency => _emergencyContent(),
      };

  Widget _medicinesContent() {
    final medications = ref.watch(onboardingProvider.select((draft) => draft.medications));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Adicione os remédios de uso contínuo. Você pode completar esta parte mais tarde.'),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Nome do remédio', controller: _firstController),
        const SizedBox(height: AppSpacing.sm),
        AppTimeField(label: 'Horário', value: _secondController.text.isEmpty ? 'Ex.: 08:00' : _secondController.text, onTap: _chooseTime),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(label: 'Adicionar remédio', icon: Icons.add, onPressed: _addMedication),
        const SizedBox(height: AppSpacing.md),
        for (final entry in medications.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: AppCard(
              child: Row(
                children: [
                  const Icon(Icons.medication_outlined),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text('${entry.$2.name} • ${entry.$2.time}')),
                  IconButton(
                    tooltip: 'Remover ${entry.$2.name}',
                    onPressed: () => ref.read(onboardingProvider.notifier).removeMedication(entry.$1),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _doctorContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Informe seu médico principal e, se quiser, o próximo compromisso.'),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'Médico principal', controller: _firstController),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(label: 'Próximo compromisso', controller: _secondController, hint: 'Ex.: Cardiologista, 15/10 às 10:00'),
        ],
      );

  Widget _emergencyContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Essas informações são demonstrativas e podem ser preenchidas depois.'),
          const SizedBox(height: AppSpacing.md),
          AppDropdown<String>(
            label: 'Tipo sanguíneo',
            value: _bloodType,
            onChanged: (value) => setState(() => _bloodType = value),
            items: const [
              DropdownMenuItem(value: 'A+', child: Text('A+')),
              DropdownMenuItem(value: 'A-', child: Text('A-')),
              DropdownMenuItem(value: 'B+', child: Text('B+')),
              DropdownMenuItem(value: 'B-', child: Text('B-')),
              DropdownMenuItem(value: 'AB+', child: Text('AB+')),
              DropdownMenuItem(value: 'AB-', child: Text('AB-')),
              DropdownMenuItem(value: 'O+', child: Text('O+')),
              DropdownMenuItem(value: 'O-', child: Text('O-')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(label: 'Alergias', controller: _secondController, maxLines: 2),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(label: 'Contato familiar principal', controller: _thirdController),
        ],
      );

  Future<void> _chooseTime() async {
    final selected = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selected == null || !mounted) return;
    setState(() => _secondController.text = selected.format(context));
  }

  Future<void> _addMedication() async {
    final name = _firstController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe o nome do remédio.')));
      return;
    }
    await ref.read(onboardingProvider.notifier).addMedication(
          name: name,
          time: _secondController.text.isEmpty ? 'Horário não informado' : _secondController.text,
        );
    _firstController.clear();
    _secondController.clear();
    if (mounted) setState(() {});
  }
}
