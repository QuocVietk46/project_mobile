import 'package:flutter/material.dart';
import 'package:shop_shoe/models/auth_token.dart';
import 'package:shop_shoe/ui/shared/dialog_utils.dart';
import '../../models/order_item.dart';
import '../../models/cart_item.dart';
import '../../services/orders_service.dart'; // Import your OrderService

class OrdersManager with ChangeNotifier {
  final List<OrderItem> _orders = [];

  final OrderService _orderService;

  OrdersManager([AuthToken? authToken])
      : _orderService = OrderService(authToken);

  set authToken(AuthToken? authToken) {
    _orderService.authToken = authToken;
  }

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      final fetchedOrders = await _orderService.fetchOrders();
      _orders.clear();
      _orders.addAll(fetchedOrders);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addOrder(BuildContext context, List<CartItem> cartProducts,
      double total, String name, String address, String phone) async {
    if (cartProducts.isEmpty) {
      showErrorDialog(
        context,
        'Vui lòng thêm sản phẩm vào giỏ hàng để đặt hàng',
      );
      return;
    }

    try {
      final newOrder = OrderItem(
        id: 'o${DateTime.now().toIso8601String()}',
        address: address,
        phone: phone,
        name: name,
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      );

      final addedOrder = await _orderService.addOrder(newOrder);
      if (addedOrder != null) {
        _orders.insert(0, addedOrder);
        showThanksDialog(
          context,
          "Cảm ơn bạn đã mua hàng tại cửa hàng của chúng tôi!",
          title: "Đặt hàng thành công",
        );
        notifyListeners();
      } else {
        showErrorDialog(
          context,
          'Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại sau.',
        );
      }
    } catch (error) {
      print(error);
      showErrorDialog(
        context,
        'Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại sau.',
      );
    }
  }
}
