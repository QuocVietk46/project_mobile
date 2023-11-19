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
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          buildAvt(context),
        ],
      ),
      body: Column(
        children: <Widget>[
          buildHeaderCart(),
          const SizedBox(height: 10),
          Expanded(
            child: buildCartDetails(cart),
          ),
          const SizedBox(height: 10),
          buildCartSummary(cart, context),
          const SizedBox(height: 10),
          buildOrderButton(cart, context),
        ],
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

          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'Search',
          //   backgroundColor: Colors.purple,
          // ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Index 1 corresponds to the 'Home' tab
            Navigator.of(context).pushReplacementNamed('/');
            Colors.purple;
          } else if (index == 0) {
            // Index 0 corresponds to the 'Cart' tab
            Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed('/');
          }
        },
      ),
    );
  }

  Widget buildAvt(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_circle),
      onPressed: () {},
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
          Consumer(
            builder: (context, value, child) => InkWell(
              onTap: () => context.read<CartManager>().clear(),
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

  Widget buildCartDetails(CartManager cart) {
    return cart.productCount == 0
        ? const Center(
            child: Text(
              'Chưa có sản phẩm nào trong giỏ hàng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView(
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
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Số lượng: ${cart.productCount}',
                style: const TextStyle(fontSize: 16),
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
          )),
    );
  }

  Widget buildOrderButton(CartManager cart, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffE65829),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextButton(
        onPressed: cart.totalAmount <= 0
            ? null
            : () {
                Navigator.of(context).pushNamed(CheckoutScreen.routeName);
              },
        child: const Text(
          'Đặt hàng',
          style:
              TextStyle(fontSize: 20, color: Color.fromARGB(255, 33, 25, 25)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
