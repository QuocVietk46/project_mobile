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
  late String selectedImageUrl;
  late List<String> imageUrls;

  @override
  void initState() {
    super.initState();
    selectedImageUrl = 'https://placekitten.com/300/200';
    imageUrls = [
      'https://placekitten.com/300/200',
      'https://placekitten.com/301/200',
      'https://placekitten.com/302/200',
    ];
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hình ảnh chính
        GestureDetector(
          onTap: () {
            // Mở hình ảnh chính lớn khi nhấp vào
            _showFullScreenImage(selectedImageUrl);
          },
          child: Image.network(
            selectedImageUrl,
            fit: BoxFit.cover,
          ),
        ),
        // Danh sách hình ảnh phụ
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Căn giữ theo trục chính
          children: imageUrls.map((imageUrl) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImageUrl = imageUrl;
                  });
                },
                child: Image.network(
                  imageUrl,
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(imageUrl),
        );
      },
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

  // Future addToCart(Product product) async {
  //   final cartManager = context.read<CartManager>();
  //   try {
  //     cartManager.addItem(product);
  //   } catch (error) {
  //     print(error);
  //   }
  // }

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
