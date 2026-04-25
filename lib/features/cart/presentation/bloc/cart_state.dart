import 'package:equatable/equatable.dart';
import 'package:quikmart/features/dashboard/domain/entites/product_entity.dart';

class CartState extends Equatable {
  final Map<ProductEntity, int> items;

  const CartState({this.items = const {}});

  int get totalItems => items.values.fold(0, (sum, count) => sum + count);
  double get totalPrice => items.entries.fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));

  CartState copyWith({Map<ProductEntity, int>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}
