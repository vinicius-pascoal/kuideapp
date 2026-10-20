import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/filter_tab_bar.dart';
import '../domain/contact.dart';
import 'contact_provider.dart';

class ContactsScreen extends ConsumerStatefulWidget { const ContactsScreen({super.key}); @override ConsumerState<ContactsScreen> createState() => _ContactsScreenState(); }
class _ContactsScreenState extends ConsumerState<ContactsScreen> { var _query = ''; var _filter = 0;
  @override Widget build(BuildContext context) { final contacts = ref.watch(contactsProvider).where((contact) { final text = '${contact.name} ${contact.relationship}'.toLowerCase(); final matchesSearch = text.contains(_query.toLowerCase()); final matchesCategory = _filter == 0 || (_filter == 1 && contact.category == ContactCategory.family) || (_filter == 2 && contact.category == ContactCategory.doctor); return matchesSearch && matchesCategory; }).toList(); return Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [AppHeader(title: 'Pessoas importantes', onBack: () => context.pop()), const SizedBox(height: AppSpacing.md), AppSearchField(onChanged: (value) => setState(() => _query = value)), const SizedBox(height: AppSpacing.sm), FilterTabBar(labels: const ['Todos', 'Família', 'Médicos'], selectedIndex: _filter, onSelected: (value) => setState(() => _filter = value)), const SizedBox(height: AppSpacing.md), for (final contact in contacts) _ContactTile(contact: contact), if (contacts.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(AppSpacing.lg), child: Text('Nenhum contato encontrado.'))), const SizedBox(height: AppSpacing.md), PrimaryButton(label: 'Adicionar contato', icon: Icons.person_add_outlined, onPressed: () => context.push('/contacts/add'))])));
  }
}
class _ContactTile extends StatelessWidget { const _ContactTile({required this.contact}); final Contact contact;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.xs), child: AppCard(tint: false, child: ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(backgroundColor: AppColors.wine, foregroundColor: AppColors.lightText, child: Text(contact.name.substring(0, 1))), title: Text(contact.name), subtitle: Text('${contact.relationship} • ${contact.phone}'), trailing: IconButton(tooltip: 'Chamada simulada para ${contact.name}', onPressed: () => context.push('/mock-call/${contact.id}'), icon: const Icon(Icons.call_outlined)))));
}
