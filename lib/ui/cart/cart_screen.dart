import 'package:flutter/material.dart';
import 'package:shop_shoe/ui/orders/orders_manager.dart';
import 'package:provider/provider.dart';

import 'cart_manager.dart';
import 'cart_item_cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(children: <Widget>[
        buildCartSummary(cart, context),
        const SizedBox(height: 10),
        Expanded(
          child: buildCartDetails(cart),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.purple,
          ),

          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'Search',
          //   backgroundColor: Colors.purple,
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'favorite',
            backgroundColor: Colors.purple,
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Index 1 corresponds to the 'Home' tab
            Navigator.of(context).pushReplacementNamed('/');
            Colors.purple;
          } else if (index == 0) {
            // Index 0 corresponds to the 'Cart' tab
            Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
          }
        },
      ),
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) => CartItemCart(
              productId: entry.key,
              cartItem: entry.value,
            ),
          )
          .toList(),
    );
  }

  Widget buildCartSummary(CartManager cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Total',
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              Chip(
                label: Text(
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              TextButton(
                onPressed: cart.totalAmount <= 0
                    ? null
                    : () {
                        context.read<OrdersManager>().addOrder(
                              cart.products,
                              cart.totalAmount,
                            );
                        cart.clear();
                      },
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: const Text('ORDER NOW'),
              ),
            ],
          )),
    );
  }
}
