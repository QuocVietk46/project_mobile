import 'package:flutter/foundation.dart';

import 'package:shop_shoe/models/auth_token.dart';
import 'package:shop_shoe/models/product.dart';

import '../../services/cart_service.dart';
import '../../models/cart_item.dart'; // Import your CartItem model

class CartManager with ChangeNotifier {
  List<CartItem> _items = [];

  final CartService _cartService;

  CartManager([AuthToken? authToken]) : _cartService = CartService(authToken);

  set authToken(AuthToken? authToken) {
    _cartService.authToken = authToken;
  }

  // Lấy dữ liệu giỏ hàng
  Future<void> fetchCartItems() async {
    _items = await _cartService.fetchCartItems();
    notifyListeners();
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(CartItem cartItem) async {
    print('idCart: ${cartItem.id}');
    final newCartItem = await _cartService.addToCart(cartItem);
    if (newCartItem != null) {
      _items.add(newCartItem);
      notifyListeners();
    }
  }

  // Cập nhật sản phẩm trong giỏ hàng
  Future<void> updateCartItem(CartItem cartItem) async {
    final index = _items.indexWhere((item) => item.id == cartItem.id);
    if (index >= 0) {
      if (await _cartService.updateCartItem(cartItem)) {
        _items[index] = cartItem;
        notifyListeners();
      }
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeSingleItem(String productId) async {
    final index = _items.indexWhere((item) => item.id == productId);
    CartItem? existingCartItem = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _cartService.removeFromCart(productId)) {
      _items.insert(index, existingCartItem);
      notifyListeners();
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  void addItem(Product product) {
    print('idProduct: ${product.id}');
    final index = _items.indexWhere((item) => item.title == product.title);
    if (index >= 0) {
      // If the item already exists in the cart, increase the quantity
      _items[index].quantity += 1;
      updateCartItem(_items[index]);
    } else {
      // If the item is not in the cart, add it as a new item
      addToCart(CartItem(
        id: product.id.toString(),
        title: product.title,
        price: product.price,
        quantity: 1,
        imageUrl: product.imageUrl,
      ));
    }
  }

  void increaseItem(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      // Increase the quantity of the item in the cart
      _items[index].quantity += 1;
      updateCartItem(_items[index]);
    }
  }

  void decreaseItem(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index >= 0 && _items[index].quantity > 1) {
      // Decrease the quantity of the item in the cart
      _items[index].quantity -= 1;
      updateCartItem(_items[index]);
    }
  }

  Future<void> clear() async {
    try {
      List<CartItem> itemsCopy = List.from(_items);

      await Future.wait(itemsCopy.map((item) => removeSingleItem(item.id)));

      _items.clear();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<CartItem> get items {
    return [..._items];
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
