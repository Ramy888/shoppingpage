import 'package:equatable/equatable.dart';

import '../Models/product_model.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllProducts extends ProductEvent {
  final List<Product> products;

  LoadAllProducts(this.products);

  @override
  List<Object?> get props => [products];
}

class AddToCart extends ProductEvent {
  final Product product;

  AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends ProductEvent {
  final Product product;

  RemoveFromCart(this.product);

  @override
  List<Object?> get props => [product];
}

class IncreaseQuantity extends ProductEvent {
  final Product product;

  IncreaseQuantity(this.product);

  @override
  List<Object?> get props => [product];
}

class DecreaseQuantity extends ProductEvent {
  final Product product;

  DecreaseQuantity(this.product);

  @override
  List<Object?> get props => [product];
}

class ToggleFavorite extends ProductEvent {
  final Product product;

  ToggleFavorite(this.product);

  @override
  List<Object?> get props => [product];
}
