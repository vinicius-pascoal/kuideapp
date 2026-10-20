import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/features/profile/presentation/profile_provider.dart';

void main() {
  test('perfil atualiza identidade e preferências localmente', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(profileProvider.notifier);
    controller.updateIdentity(name: 'Maria Oliveira', email: 'maria@exemplo.local');
    controller.setTextScale(1.2);
    controller.setReminderVolume(.4);
    final profile = container.read(profileProvider);
    expect(profile.name, 'Maria Oliveira');
    expect(profile.textScale, 1.2);
    expect(profile.reminderVolume, .4);
  });
}
