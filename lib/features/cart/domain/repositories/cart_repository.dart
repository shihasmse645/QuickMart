
import 'package:quikmart/features/cart/domain/entites/cart_item_entity.dart';
import 'package:quikmart/features/dashboard/domain/entites/product_entity.dart';

abstract class CartRepository {
  List<CartItemEntity> getCartItems();
  void addItem(ProductEntity product);
  void updateQuantity(int productId, int delta);
}
