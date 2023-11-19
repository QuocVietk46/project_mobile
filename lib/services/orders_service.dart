import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/order_item.dart'; // Assuming you have an OrderItem model
import 'firebase_service.dart';

class OrderService extends FirebaseService {
  OrderService(super.authToken);

  Future<List<OrderItem>> fetchOrders() async {
    final List<OrderItem> orderItems = [];

    try {
      final orderUrl =
          Uri.parse('$databaseUrl/userOrder/$userId.json?auth=$token');
      final response = await http.get(orderUrl);

      if (response.statusCode != 200) {
        // Handle the case where the response status code is not 200
        print('Error: ${response.statusCode}');
        return orderItems;
      }

      final dynamic orderData = json.decode(response.body);

      if (orderData == null || orderData.isEmpty) {
        // Handle the case where orderData is null or empty
        print('No orders found');
        return orderItems;
      }

      final orderMap = orderData as Map<String, dynamic>;

      orderMap.forEach((orderId, orderItem) {
        orderItems.add(OrderItem.fromJson({
          'id': orderId,
          ...?orderItem,
        }));
      });

      return orderItems;
    } catch (error) {
      print(error);
      return orderItems;
    }
  }

  Future<OrderItem?> addOrder(OrderItem orderItem) async {
    try {
      final url = Uri.parse('$databaseUrl/userOrder/$userId.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(orderItem.toJson()..addAll({'userId': userId})),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return orderItem.copyWith(id: json.decode(response.body)['name']);
    } catch (error) {
      print(error);
      return null;
    }
  }
}
