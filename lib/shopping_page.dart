import 'package:cart/Events/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc/product_bloc.dart';
import 'States/product_state.dart';
import 'Widgets/product_widget.dart';

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        // Initialize cart item count
        int cartItemCount = 0;

        // Check the current state and manage cart item count
        if (state is ProductsLoaded) {
          cartItemCount = state.cart.values.fold(0, (sum, quantity) => sum + quantity);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Shopping Page"),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Navigate to Cart Page
                    },
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '$cartItemCount',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductState state) {
    if (state is ProductsInitial) {
      // Show loading indicator when products are loading
      return Center(child: CircularProgressIndicator());
    } else if (state is ProductsLoaded) {
      // Show products in grid when loaded
      return GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: state.products[index]);
        },
      );
    }  else {
      // Default loading state before products are loaded
      return Center(child: Text('No products available.'));
    }
  }
}
