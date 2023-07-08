import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ksfood/models/cart_item.dart';
import 'package:ksfood/models/cart_model.dart';
import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/models/payment_model.dart';
import 'package:ksfood/models/product.dart';
import 'package:uuid/uuid.dart';

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
          final newCartItem = CartItem(
            product: event.product,
            quantity: event.quantity,
            note: event.note,
          );

          bool found = false;

          // Check if the cart with the given merchant already exists
          final existingCartIndex = state.carts?.indexWhere(
            (cart) => cart.merchant.id == event.merchant.id,
          );

          if (existingCartIndex != null && existingCartIndex >= 0) {
            // Update the existing cart if the product already exists
            final existingCart = state.carts![existingCartIndex];
            final updatedItems = List<CartItem>.from(existingCart.items);

            for (var i = 0; i < updatedItems.length; i++) {
              if (updatedItems[i].product.id == newCartItem.product.id) {
                final updatedItem = updatedItems[i].copyWith(
                  quantity: (updatedItems[i].quantity + newCartItem.quantity),
                  note: newCartItem.note,
                );
                updatedItems[i] = updatedItem;
                found = true;
                break;
              }
            }

            if (!found) {
              updatedItems.add(newCartItem); // Add a new item to the cart
            }

            final updatedCart = existingCart.copyWith(
              items: updatedItems,
            );

            // Update the cart in the state
            final updatedCarts = List<Cart>.from(state.carts ?? []);
            updatedCarts[existingCartIndex] = updatedCart;

            emit(
              state.copyWith(
                status: CartStateStatus.loaded,
                carts: updatedCarts,
              ),
            );
          } else {
            // Create a new cart with the merchant and cart item
            final newCart = Cart(
              id: const Uuid().v4(),
              items: [newCartItem],
              merchant: event.merchant,
              timeCreated: DateTime.now(),
            );

            // Add the new cart to the state
            final updatedCarts = List<Cart>.from(state.carts ?? []);
            updatedCarts.add(newCart);

            emit(
              state.copyWith(
                merchant: event.merchant,
                status: CartStateStatus.loaded,
                carts: updatedCarts,
              ),
            );
          }

          log(state.carts.toString());
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
          final updatedCarts = List<Cart>.from(state.carts ?? []);
          final cartsToRemove =
              <Cart>[]; // List to track carts that need to be removed

          for (var cart in updatedCarts) {
            final updatedItems = List<CartItem>.from(cart.items);

            // Find the cart item with the specified product id
            final index = updatedItems.indexWhere(
              (item) => item.product.id == event.product.id,
            );

            if (index != -1) {
              final currentItem = updatedItems[index];

              if (currentItem.quantity > event.quantity) {
                // Decrease the quantity of the cart item
                final updatedItem = currentItem.copyWith(
                  quantity: currentItem.quantity - event.quantity,
                );
                updatedItems[index] = updatedItem;
              } else {
                // Remove the cart item if its quantity is less than or equal to the specified quantity
                updatedItems.removeAt(index);
              }
            }

            // Update the items of the cart
            final updatedCart = cart.copyWith(items: updatedItems);

            if (updatedCart.items.isEmpty) {
              // Add the cart to the list of carts to be removed
              cartsToRemove.add(cart);
            } else {
              final cartIndex = updatedCarts.indexOf(cart);
              updatedCarts[cartIndex] = updatedCart;
            }
          }

          // Remove the carts that need to be removed
          updatedCarts.removeWhere((cart) => cartsToRemove.contains(cart));

          emit(
            state.copyWith(
              status: CartStateStatus.loaded,
              carts: updatedCarts,
            ),
          );

          log(state.carts.toString());
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
              carts: [],
            ),
          );
          log(state.carts.toString());
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
