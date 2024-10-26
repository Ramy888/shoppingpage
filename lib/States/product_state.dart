import 'package:equatable/equatable.dart';

import '../Models/product_model.dart';

abstract class ProductState extends Equatable {

  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductState{}

class ProductsLoaded extends ProductState{

  final List<Product> products;
  final Set<Product> favorites;
  final Map<Product, int> cart;
  const ProductsLoaded({required this.products, required this.favorites, required this.cart});

  @override
  List<Object?> get props => [products, favorites, cart];
}
