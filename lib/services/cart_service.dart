import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cart_item.dart';

import 'firebase_service.dart';

class CartService extends FirebaseService {
  CartService(super.authToken);

  Future<List<CartItem>> fetchCartItems() async {
    final List<CartItem> cartItems = [];

    try {
      final cartUrl =
          Uri.parse('$databaseUrl/userCart/$userId.json?auth=$token');
      final response = await http.get(cartUrl);

      print(response.body);

      if (response.statusCode != 200) {
        // Handle the case where the response status code is not 200
        print('Error: ${response.statusCode}');
        return cartItems;
      }

      final dynamic cartData = json.decode(response.body);

      if (cartData == null || cartData.isEmpty) {
        // Handle the case where cartData is null or empty
        print('Cart is empty');
        return cartItems;
      }

      final cartMap = cartData as Map<String, dynamic>;

      cartMap.forEach((cartItemId, cartItem) {
        cartItems.add(CartItem.fromJson({
          'id': cartItemId,
          ...?cartItem,
        }));
      });

      return cartItems;
    } catch (error) {
      print(error);
      return cartItems;
    }
  }

  Future<CartItem?> addToCart(CartItem cartItem) async {
    try {
      final url = Uri.parse('$databaseUrl/userCart/$userId.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(cartItem.toJson()..addAll({'userId': userId})),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return cartItem.copyWith(id: json.decode(response.body)['name']);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateCartItem(CartItem cartItem) async {
    try {
      print('updateCartItem: ${cartItem.id}');
      final url = Uri.parse(
          '$databaseUrl/userCart/$userId/${cartItem.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(cartItem.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> removeFromCart(String cartId) async {
    try {
      final url =
          Uri.parse('$databaseUrl/userCart/$userId/$cartId.json?auth=$token');
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> clearCart() async {
    try {
      final url = Uri.parse('$databaseUrl/userCart/$userId.json?auth=$token');
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
