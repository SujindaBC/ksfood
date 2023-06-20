import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ksfood/models/cart_item.dart';
import 'package:ksfood/models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<AddProductToCart>(
      (AddProductToCart event, Emitter<CartState> emit) {
        emit(
          state.copyWith(
            status: CartStateStatus.loading,
          ),
        );
        try {
          final newCartItems = CartItem(
            product: event.product,
            quantity: event.quantity,
            comment: event.comment,
          );
          List<CartItem> updatedItems = List.of(state.items ?? []);
          bool found = false;

          for (var i = 0; i < updatedItems.length; i++) {
            if (updatedItems[i].product.id == newCartItems.product.id) {
              final updatedItem = updatedItems[i].copyWith(
                quantity: updatedItems[i].quantity + newCartItems.quantity,
                comment: newCartItems.comment,
              );
              updatedItems[i] = updatedItem;
              found = true;
              break;
            }
          }

          if (!found) {
            updatedItems.add(newCartItems); // Add a new item to the cart
          }

          emit(
            state.copyWith(
              merchantId: event.merchantId,
              status: CartStateStatus.loaded,
              items: updatedItems,
            ),
          );

          log(
            state.items.toString(),
          );
        } catch (error) {
          emit(
            state.copyWith(
              status: CartStateStatus.error,
            ),
          );
          log(state.status.toString());
        }
      },
    );

    on<RemoveProductFromCart>(
      (RemoveProductFromCart event, Emitter<CartState> emit) {
        emit(
          state.copyWith(
            status: CartStateStatus.loading,
          ),
        );
        try {
          emit(
            state.copyWith(
              status: CartStateStatus.loaded,
              items: [],
            ),
          );
          log(state.items.toString());
        } catch (error) {
          emit(
            state.copyWith(
              status: CartStateStatus.error,
            ),
          );
        }
      },
    );

    on<ClearCart>(
      (ClearCart event, Emitter<CartState> emit) {
        emit(
          state.copyWith(
            status: CartStateStatus.loading,
          ),
        );
        try {
          emit(
            state.copyWith(
              status: CartStateStatus.loaded,
              items: [],
            ),
          );
          log(state.items.toString());
        } catch (error) {
          emit(
            state.copyWith(
              status: CartStateStatus.error,
            ),
          );
        }
      },
    );
  }
}
