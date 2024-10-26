import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String image;
  final String title;
  final String seller;

  const Product({
    required this.id,
    required this.image,
    required this.title,
    required this.seller,
  });

  @override
  List<Object?> get props => [id, image, title, seller];

  static List<Product> products = List.generate(
    10,
        (index) => Product(
      id: 'product_$index',
      image: 'https://via.placeholder.com/150', // Replace with actual images
      title: 'Product $index',
      seller: 'Seller $index',
    ),
  );
}
