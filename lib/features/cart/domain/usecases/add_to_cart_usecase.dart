import 'package:quikmart/features/dashboard/domain/entites/product_entity.dart';

import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  void call(ProductEntity product) {
    repository.addItem(product);
  }
}
