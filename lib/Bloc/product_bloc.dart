import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/product_model.dart';
import '../Events/product_event.dart';
import '../States/product_state.dart';
import 'dart:developer' as dev;

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final Map<Product, int> _cart = {}; // Stores product quantities in the cart
  final Set<Product> _favorites = {}; // Stores favorite products

  ProductBloc() : super(ProductsInitial()) {
    on<LoadAllProducts>(_onLoadAllProducts);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  // Load all products
  void _onLoadAllProducts(LoadAllProducts event, Emitter<ProductState> emit) async {
    emit(ProductsInitial()); // Emit loading state before fetching products
    await Future.delayed(Duration(seconds: 1)); // Simulate loading delay
    emit(ProductsLoaded(products: List<Product>.from(event.products),
        favorites: Set<Product>.from(_favorites), cart: Map<Product,int>.from(_cart)));  }

  // Handle adding a product to the cart
  void _onAddToCart(AddToCart event, Emitter<ProductState> emit) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      _cart.update(event.product, (quantity) => quantity + 1, ifAbsent: () => 1);
      dev.log("ShowCartQuant: ${event.product.title} ,,, state: $state");
      emit(ProductsLoaded(products: List<Product>.from(currentState.products),
          favorites: Set<Product>.from(_favorites), cart: Map<Product,int>.from(_cart)));
    }
  }

  // Handle removing a product from the cart
  void _onRemoveFromCart(RemoveFromCart event, Emitter<ProductState> emit) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      _cart.remove(event.product);
      emit(ProductsLoaded(products: List<Product>.from(currentState.products),
          favorites: Set<Product>.from(_favorites), cart: Map<Product,int>.from(_cart)));    }
  }

  // Handle increasing product quantity
  void _onIncreaseQuantity(IncreaseQuantity event, Emitter<ProductState> emit) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      if (_cart.containsKey(event.product)) {
        _cart[event.product] = _cart[event.product]! + 1;
      }
      emit(ProductsLoaded(products: List<Product>.from(currentState.products),
          favorites: Set<Product>.from(_favorites), cart: Map<Product,int>.from(_cart)));    }
  }

  // Handle decreasing product quantity
  void _onDecreaseQuantity(DecreaseQuantity event, Emitter<ProductState> emit) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      if (_cart.containsKey(event.product)) {
        if (_cart[event.product]! > 1) {
          _cart[event.product] = _cart[event.product]! - 1;
        } else {
          _cart.remove(event.product);
        }
      }
      emit(ProductsLoaded(products: List<Product>.from(currentState.products),
          favorites: Set<Product>.from(_favorites), cart: Map<Product,int>.from(_cart)));    }
  }

  // Handle toggling product as favorite
  void _onToggleFavorite(ToggleFavorite event, Emitter<ProductState> emit) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;

      // Toggle favorite status
      if (_favorites.contains(event.product)) {
        _favorites.remove(event.product);
        dev.log("removedToFavs");
      } else {
        _favorites.add(event.product);
        dev.log("addedToFavs");
      }

      // Emit new state with updated favorites
      emit(ProductsLoaded(products: List<Product>.from(currentState.products),
          favorites: Set<Product>.from(_favorites), cart: Map<Product,int>.from(_cart)));    }
  }

}
