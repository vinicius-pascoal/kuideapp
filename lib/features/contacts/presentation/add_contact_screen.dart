import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import '../domain/contact.dart';
import 'contact_provider.dart';
class AddContactScreen extends ConsumerStatefulWidget { const AddContactScreen({super.key}); @override ConsumerState<AddContactScreen> createState() => _AddContactScreenState(); }
class _AddContactScreenState extends ConsumerState<AddContactScreen> { final _form = GlobalKey<FormState>(); final _name = TextEditingController(); final _relationship = TextEditingController(); final _phone = TextEditingController(); var _category = ContactCategory.family; var _showHome = false;
  @override void dispose() { _name.dispose(); _relationship.dispose(); _phone.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Form(key: _form, child: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [AppHeader(title: 'Adicionar contato', onBack: () => context.pop()), const SizedBox(height: AppSpacing.lg), AppTextField(label: 'Nome', controller: _name, validator: _required('Informe o nome.')), const SizedBox(height: AppSpacing.sm), AppTextField(label: 'Relação', controller: _relationship, validator: _required('Informe a relação.')), const SizedBox(height: AppSpacing.sm), AppTextField(label: 'Telefone', controller: _phone, keyboardType: TextInputType.phone, validator: _required('Informe o telefone.')), const SizedBox(height: AppSpacing.sm), AppDropdown<ContactCategory>(label: 'Categoria', value: _category, onChanged: (value) => setState(() => _category = value ?? _category), items: ContactCategory.values.map((category) => DropdownMenuItem(value: category, child: Text(category.label))).toList()), CheckboxListTile(value: _showHome, onChanged: (value) => setState(() => _showHome = value ?? false), title: const Text('Mostrar na Home'), controlAffinity: ListTileControlAffinity.leading, contentPadding: EdgeInsets.zero), PrimaryButton(label: 'Salvar contato', onPressed: _save)]))));
  String? Function(String?) _required(String text) => (value) => value == null || value.trim().isEmpty ? text : null;
  void _save() { if (!_form.currentState!.validate()) return; ref.read(contactsProvider.notifier).add(Contact(id: DateTime.now().microsecondsSinceEpoch.toString(), name: _name.text.trim(), relationship: _relationship.text.trim(), phone: _phone.text.trim(), category: _category, showOnHome: _showHome)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contato incluído com sucesso.'))); context.pop(); }
}
