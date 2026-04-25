import 'package:quikmart/features/cart/domain/entites/cart_item_entity.dart';

import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  List<CartItemEntity> call() {
    return repository.getCartItems();
  }
}
