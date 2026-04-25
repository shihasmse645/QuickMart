import '../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  void call(int productId, int delta) {
    repository.updateQuantity(productId, delta);
  }
}
