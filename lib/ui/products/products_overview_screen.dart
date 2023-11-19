import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_shoe/ui/products/top_right_badge.dart';
import 'package:shop_shoe/ui/screens.dart';
import 'package:shop_shoe/ui/shared/app_drawer.dart';

import 'products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;

  get isHomePageSelected => null;

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          buildProductFilterMenu(),
          // buildShoppingCartIcon(),
          buildAvt(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
              valueListenable: _showOnlyFavorites,
              builder: (ctx, onlyFavorites, child) {
                return ProductsGrid(onlyFavorites);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
              backgroundColor: Colors.purple,
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              // Index 1 corresponds to the 'Home' tab
              Navigator.of(context).pushReplacementNamed('/');
            } else if (index == 1) {
              // Index 0 corresponds to the 'Cart' tab
              Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
            }
          }),
    );
  }

  Widget buildHomeIcon() {
    return IconButton(
      icon: const Icon(Icons.home),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }

  // Widget buildCartIcon() {
  //   return IconButton(
  //     icon: const Icon(Icons.shopping_cart),
  //     onPressed: () {
  //       Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
  //     },
  //   );
  // }

  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        );
      },
    );
  }

  Widget buildAvt(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_circle),
      onPressed: () {},
    );
  }

  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        // setState(() {
        if (selectedValue == FilterOptions.favorites) {
          _showOnlyFavorites.value = true;
        } else {
          _showOnlyFavorites.value = false;
        }
        //} );
      },
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Chỉ chọn yêu thích'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Xem tất cả'),
        )
      ],
    );
  }
}
