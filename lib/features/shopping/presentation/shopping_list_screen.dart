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
import '../../../shared/widgets/mock_action_dialog.dart';
import '../domain/shopping_item.dart';
import 'shopping_provider.dart';

class ShoppingListScreen extends ConsumerStatefulWidget { const ShoppingListScreen({super.key}); @override ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState(); }
class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> { var _tab = 0;
  @override Widget build(BuildContext context) { final all = ref.watch(shoppingProvider); final items = all.where((item) => _tab == 0 ? !item.inCart : item.inCart).toList(); return Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
    AppHeader(title: 'Compras', onBack: () => context.pop()), const SizedBox(height: AppSpacing.md),
    FilterTabBar(labels: ['Pendentes (${all.where((item) => !item.inCart).length})', 'No carrinho (${all.where((item) => item.inCart).length})'], selectedIndex: _tab, onSelected: (value) => setState(() => _tab = value)), const SizedBox(height: AppSpacing.md),
    for (final item in items) _ShoppingTile(item: item), if (items.isEmpty) const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: Center(child: Text('Nenhum item nesta lista.'))), const SizedBox(height: AppSpacing.md),
    PrimaryButton(label: 'Adicionar item', icon: Icons.add, onPressed: () => _showAddItem(context)), const SizedBox(height: AppSpacing.sm),
    SecondaryButton(label: 'Enviar lista pelo WhatsApp', icon: Icons.share_outlined, onPressed: () => MockActionDialog.show(context, title: 'Compartilhamento simulado', message: 'Nenhuma mensagem será enviada ao WhatsApp. Esta é apenas uma prévia local.')),
  ])));
  }
}
class _ShoppingTile extends ConsumerWidget { const _ShoppingTile({required this.item}); final ShoppingItem item;
  @override Widget build(BuildContext context, WidgetRef ref) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.xs), child: AppCard(tint: false, child: CheckboxListTile(value: item.inCart, onChanged: (_) => ref.read(shoppingProvider.notifier).toggleCart(item.id), title: Text(item.name), subtitle: Text(item.quantity), secondary: Icon(item.inCart ? Icons.shopping_cart : Icons.shopping_cart_outlined, color: AppColors.wine), controlAffinity: ListTileControlAffinity.trailing, contentPadding: EdgeInsets.zero)));
}
Future<void> _showAddItem(BuildContext context) => showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (context) => const _AddItemSheet());
class _AddItemSheet extends ConsumerStatefulWidget { const _AddItemSheet(); @override ConsumerState<_AddItemSheet> createState() => _AddItemSheetState(); }
class _AddItemSheetState extends ConsumerState<_AddItemSheet> { final _name = TextEditingController(); final _quantity = TextEditingController(text: '1');
  @override void dispose() { _name.dispose(); _quantity.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Padding(padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('Novo item', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: AppSpacing.md), AppTextField(label: 'Item', controller: _name), const SizedBox(height: AppSpacing.sm), AppTextField(label: 'Quantidade', controller: _quantity), const SizedBox(height: AppSpacing.md), PrimaryButton(label: 'Adicionar', onPressed: () { final name = _name.text.trim(); if (name.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe o item.'))); return; } ref.read(shoppingProvider.notifier).add(ShoppingItem(id: DateTime.now().microsecondsSinceEpoch.toString(), name: name, quantity: _quantity.text.trim().isEmpty ? '1' : _quantity.text.trim())); Navigator.of(context).pop(); })]));
}
