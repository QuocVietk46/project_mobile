import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_shoe/ui/checkout/checkout_screen.dart';
import 'cart_manager.dart';
import 'cart_item_cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fetchCartItems = context.read<CartManager>().fetchCartItems();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: fetchCartItems,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return buildCart(context);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
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

  Widget buildCart(BuildContext context) {
    return Column(
      children: <Widget>[
        buildHeaderCart(),
        const SizedBox(height: 10),
        Expanded(
          child: buildCartDetails(),
        ),
        const SizedBox(height: 10),
        buildCartSummary(),
        const SizedBox(height: 10),
        buildOrderButton(),
      ],
    );
  }

  Widget buildHeaderCart() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Giỏ hàng',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Consumer<CartManager>(
            builder: (context, cart, child) => InkWell(
              onTap: () => cart.clear(),
              child: const Icon(
                size: 30,
                Icons.delete_outline_outlined,
                color: Color(0xffE65829), // Màu icon
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCartDetails() {
    return Consumer<CartManager>(
      builder: (context, cart, child) => cart.itemCount == 0
          ? const Center(
              child: Text(
                'Giỏ hàng rỗng',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Expanded(
              child: ListView(
                children: cart.items
                    .map(
                      (item) => CartItemCart(
                        productId: item.id,
                        cartItem: item,
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  Widget buildCartSummary() {
    return Consumer<CartManager>(
      builder: (context, cart, child) => Card(
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Tổng cộng:',
                style: TextStyle(fontSize: 16),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderButton() {
    return Consumer<CartManager>(
      builder: (context, cart, child) => cart.itemCount == 0
          ? const SizedBox.shrink()
          : InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(CheckoutScreen.routeName);
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffE65829),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CheckoutScreen.routeName);
                  },
                  child: const Text(
                    'Đặt hàng',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 33, 25, 25)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
    );
  }
}
