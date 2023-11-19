import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shoe/ui/cart/cart_manager.dart';
import 'package:shop_shoe/ui/products/products_manager.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen(this.product, {super.key});

  final Product product;

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black26,
                ),
              ),
            ],
          ),
          _buildProductTitle(),
          _buildProductPrice(),
          _buildProductDescription(),
        ],
      ),
      floatingActionButton: _buildAddToCartButton(context),
    );
  }

  Widget _buildProductImage() {
    return SizedBox(
      child: Image.network(
        widget.product.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProductTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        widget.product.title,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '${widget.product.price} VNĐ',
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        widget.product.description,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer(
        builder: (context, value, child) => Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.orange.shade400,
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            color: Colors.white,
            onPressed: () {
              context.read<CartManager>().addItem(widget.product);
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(context) {
    return AppBar(
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.black54,
        padding: const EdgeInsets.only(left: 10),
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: widget.product.isFavoriteListenable,
          builder: (context, isFavorite, child) {
            return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: const EdgeInsets.only(right: 10),
              icon: Icon(
                widget.product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              color: widget.product.isFavorite
                  ? Colors.orange.shade400
                  : const Color(0xffE1E2E4),
              onPressed: () {
                context
                    .read<ProductsManager>()
                    .toggleFavoriteStatus(widget.product);
              },
            );
          },
        ),
      ],
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );
  }
}
