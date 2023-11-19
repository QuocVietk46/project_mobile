import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_shoe/ui/products/products_manager.dart';
import 'product_detail_screen.dart';

import '../../models/product.dart';

class ProductGridTitle extends StatelessWidget {
  const ProductGridTitle(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFavoriteProduct(context),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
          ),
        ),
        buildTitleProduct(context),
      ],
    );
  }

  Widget buildTitleProduct(BuildContext context) {
    return Column(
      children: [
        Text(
          product.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        Text(
          '\$${product.price}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget buildFavoriteProduct(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: product.isFavoriteListenable,
      builder: (context, isFavorite, child) {
        return IconButton(
          alignment: Alignment.topLeft,
          icon: Icon(
            product.isFavorite ? Icons.favorite : Icons.favorite_border,
          ),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            context.read<ProductsManager>().toggleFavoriteStatus(product);
          },
        );
      },
    );
  }
}
