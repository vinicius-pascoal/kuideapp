import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/profile.dart';
final profileProvider = NotifierProvider<ProfileController, UserProfile>(ProfileController.new);
class ProfileController extends Notifier<UserProfile> { @override UserProfile build() => const UserProfile(name: 'Maria Santos', email: 'maria.santos@exemplo.local', age: 72, bloodType: 'O+', allergies: 'Penicilina', plan: 'Plano Bem-Estar', caregiver: 'Ana Santos', textScale: 1, reminderVolume: .7); void updateIdentity({required String name, required String email}) => state = state.copyWith(name: name, email: email); void setTextScale(double value) => state = state.copyWith(textScale: value); void setReminderVolume(double value) => state = state.copyWith(reminderVolume: value); }
