import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/features/appointments/domain/appointment.dart';
import 'package:kuideapp/features/appointments/presentation/appointment_provider.dart';
import 'package:kuideapp/features/shopping/domain/shopping_item.dart';
import 'package:kuideapp/features/shopping/presentation/shopping_provider.dart';

void main() {
  test('compromisso incluído é ordenado por data', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final appointment = Appointment(id: 'soon', type: AppointmentType.exam, title: 'Exame', clinic: 'Lab', dateTime: DateTime.now().add(const Duration(hours: 1)));
    container.read(appointmentsProvider.notifier).add(appointment);
    expect(container.read(appointmentsProvider).first.id, 'soon');
  });

  test('item de compra move para o carrinho', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(shoppingProvider.notifier).add(const ShoppingItem(id: 'coffee', name: 'Café', quantity: '1'));
    container.read(shoppingProvider.notifier).toggleCart('coffee');
    expect(container.read(shoppingProvider).where((item) => item.id == 'coffee').single.inCart, isTrue);
  });
}
