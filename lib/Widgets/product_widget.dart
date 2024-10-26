import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Bloc/product_bloc.dart';
import '../Events/product_event.dart';
import '../Models/product_model.dart';
import '../States/product_state.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              // Image Carousel with Smooth Indicator
              SizedBox(
                height: 120,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3, // Set to the number of images per product
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.product.image,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    bool isFavorite = state is ProductsLoaded &&
                        state.favorites.contains(widget.product);
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        context
                            .read<ProductBloc>()
                            .add(ToggleFavorite(widget.product));
                      },
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3, // Number of images for the product
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              widget.product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            widget.product.seller,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              bool inCart = state is ProductsLoaded &&
                  state.cart.containsKey(widget.product);

              if (state is ProductsInitial) {
                return Center(child: CircularProgressIndicator());
              }

              return inCart
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            context
                                .read<ProductBloc>()
                                .add(DecreaseQuantity(widget.product));
                          },
                        ),
                        Text(
                          '${state.cart[widget.product] ?? 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            context
                                .read<ProductBloc>()
                                .add(IncreaseQuantity(widget.product));
                          },
                        ),
                      ],
                    )
                  : Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.green,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<ProductBloc>()
                              .add(AddToCart(widget.product));
                        },
                        child: Text("Add to Cart"),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
