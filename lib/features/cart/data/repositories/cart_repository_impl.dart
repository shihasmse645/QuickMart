import 'package:quikmart/features/cart/domain/entites/cart_item_entity.dart';
import 'package:quikmart/features/dashboard/domain/entites/product_entity.dart';

import '../../domain/repositories/cart_repository.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  // In-memory management strategy
  final List<CartItemModel> _cartItems = [];

  @override
  List<CartItemEntity> getCartItems() {
    return List<CartItemEntity>.unmodifiable(_cartItems);
  }

  @override
  void addItem(ProductEntity product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // Item exists, increment quantity
      final existingItem = _cartItems[index];
      _cartItems[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      // Item does not exist, add new item
      _cartItems.add(CartItemModel(product: product, quantity: 1));
    }
  }

  @override
  void updateQuantity(int productId, int delta) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      final existingItem = _cartItems[index];
      final newQuantity = existingItem.quantity + delta;

      if (newQuantity <= 0) {
        // Remove item if quantity hits zero
        _cartItems.removeAt(index);
      } else {
        // Update quantity
        _cartItems[index] = existingItem.copyWith(quantity: newQuantity);
      }
    }
  }
}
