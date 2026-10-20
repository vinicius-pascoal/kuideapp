import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/shopping_item.dart';
final shoppingProvider = NotifierProvider<ShoppingController, List<ShoppingItem>>(ShoppingController.new);
class ShoppingController extends Notifier<List<ShoppingItem>> { @override List<ShoppingItem> build() => const [ShoppingItem(id: 'milk', name: 'Leite desnatado', quantity: '2'), ShoppingItem(id: 'fruit', name: 'Frutas', quantity: '1 kg'), ShoppingItem(id: 'rice', name: 'Arroz integral', quantity: '1 pacote'), ShoppingItem(id: 'eggs', name: 'Ovos', quantity: '1 dúzia')]; void add(ShoppingItem item) => state = [...state, item]; void toggleCart(String id) => state = [for (final item in state) if (item.id == id) item.copyWith(inCart: !item.inCart) else item]; }
