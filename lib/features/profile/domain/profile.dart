class UserProfile {
  const UserProfile({required this.name, required this.email, required this.age, required this.bloodType, required this.allergies, required this.plan, required this.caregiver, required this.textScale, required this.reminderVolume});
  final String name; final String email; final int age; final String bloodType; final String allergies; final String plan; final String caregiver; final double textScale; final double reminderVolume;
  UserProfile copyWith({String? name, String? email, double? textScale, double? reminderVolume}) => UserProfile(name: name ?? this.name, email: email ?? this.email, age: age, bloodType: bloodType, allergies: allergies, plan: plan, caregiver: caregiver, textScale: textScale ?? this.textScale, reminderVolume: reminderVolume ?? this.reminderVolume);
}
