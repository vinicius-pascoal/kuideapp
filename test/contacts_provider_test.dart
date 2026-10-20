import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/features/contacts/domain/contact.dart';
import 'package:kuideapp/features/contacts/presentation/contact_provider.dart';

void main() {
  test('contato local é incluído e pode ser filtrado por categoria', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(contactsProvider.notifier).add(const Contact(id: 'new', name: 'Carla', relationship: 'Filha', phone: '11999990000', category: ContactCategory.family, showOnHome: true));
    final families = container.read(contactsProvider).where((contact) => contact.category == ContactCategory.family);
    expect(families.any((contact) => contact.id == 'new'), isTrue);
  });
}
