import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shoe/ui/cart/cart_screen.dart';

import '../shared/app_drawer.dart';
import 'edit_product_screen.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final productsManager = ProductsManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: context.read<ProductsManager>().fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => print('refresh products'),
            child: buildUserProductListView(),
          );
        },
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
            } else if (index == 0) {
              // Index 0 corresponds to the 'Cart' tab
              Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
            }
          }),
    );
  }

  Widget buildUserProductListView() {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              const Divider(),
              Table(
                border: TableBorder.all(
                    color: Colors.black26, width: 1, style: BorderStyle.solid),
                children: [
                  TableRow(children: [
                    UserProductListTile(
                      productsManager.items[i],
                    ),
                  ]),
                ],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
        );
      },
    );
  }
}
