import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/onboarding_mock_repository.dart';
import '../domain/onboarding_draft.dart';

final onboardingRepositoryProvider =
    Provider<OnboardingRepository>((ref) => MockOnboardingRepository());

final onboardingProvider = NotifierProvider<OnboardingController, OnboardingDraft>(
  OnboardingController.new,
);

class OnboardingController extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  Future<void> addMedication({required String name, required String time}) {
    return _save(
      state.copyWith(medications: [...state.medications, MedicationDraft(name: name, time: time)]),
    );
  }

  Future<void> removeMedication(int index) {
    final medications = [...state.medications]..removeAt(index);
    return _save(state.copyWith(medications: medications));
  }

  Future<void> saveDoctorDetails({required String doctor, required String appointment}) =>
      _save(state.copyWith(primaryDoctor: doctor, nextAppointment: appointment));

  Future<void> saveEmergencyDetails({
    required String bloodType,
    required String allergies,
    required String familyContact,
    required bool completed,
  }) =>
      _save(
        state.copyWith(
          bloodType: bloodType,
          allergies: allergies,
          familyContact: familyContact,
          completed: completed,
        ),
      );

  Future<void> _save(OnboardingDraft draft) async {
    state = draft;
    await ref.read(onboardingRepositoryProvider).save(draft);
  }
}
