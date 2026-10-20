class MedicationDraft {
  const MedicationDraft({required this.name, required this.time});

  final String name;
  final String time;
}

class OnboardingDraft {
  const OnboardingDraft({
    this.medications = const [],
    this.primaryDoctor = '',
    this.nextAppointment = '',
    this.bloodType = '',
    this.allergies = '',
    this.familyContact = '',
    this.completed = false,
  });

  final List<MedicationDraft> medications;
  final String primaryDoctor;
  final String nextAppointment;
  final String bloodType;
  final String allergies;
  final String familyContact;
  final bool completed;

  OnboardingDraft copyWith({
    List<MedicationDraft>? medications,
    String? primaryDoctor,
    String? nextAppointment,
    String? bloodType,
    String? allergies,
    String? familyContact,
    bool? completed,
  }) => OnboardingDraft(
        medications: medications ?? this.medications,
        primaryDoctor: primaryDoctor ?? this.primaryDoctor,
        nextAppointment: nextAppointment ?? this.nextAppointment,
        bloodType: bloodType ?? this.bloodType,
        allergies: allergies ?? this.allergies,
        familyContact: familyContact ?? this.familyContact,
        completed: completed ?? this.completed,
      );
}
