import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikmart/features/dashboard/domain/entites/product_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>((event, emit) {
      final updatedItems = Map<ProductEntity, int>.from(state.items);
      if (updatedItems.containsKey(event.product)) {
        updatedItems[event.product] = updatedItems[event.product]! + 1;
      } else {
        updatedItems[event.product] = 1;
      }
      emit(state.copyWith(items: updatedItems));
    });

    on<RemoveFromCartEvent>((event, emit) {
      final updatedItems = Map<ProductEntity, int>.from(state.items);
      if (updatedItems.containsKey(event.product)) {
        if (updatedItems[event.product]! > 1) {
          updatedItems[event.product] = updatedItems[event.product]! - 1;
        } else {
          updatedItems.remove(event.product);
        }
        emit(state.copyWith(items: updatedItems));
      }
    });

    on<ClearCartEvent>((event, emit) {
      emit(const CartState(items: {}));
    });
  }
}
