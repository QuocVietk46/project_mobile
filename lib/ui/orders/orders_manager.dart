import 'package:flutter/material.dart';
import 'package:shop_shoe/ui/shared/dialog_utils.dart';
import '../../models/order_item.dart';
import '../../models/cart_item.dart';

class OrdersManager with ChangeNotifier {
  final List<OrderItem> _orders = [];

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  addOrder(context, List<CartItem> cartProducts, double total, String name,
      String address, String phone) async {
    if (cartProducts.isEmpty) {
      showErrorDialog(
        context,
        'Vui lòng thêm sản phẩm vào giỏ hàng để đặt hàng',
      );
      return;
    }
    _orders.insert(
      0,
      OrderItem(
        id: 'o${DateTime.now().toIso8601String()}',
        address: address,
        phone: phone,
        name: name,
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    showThanksDialog(
        context, "Cảm ơn bạn đã mua hàng tại cửa hàng của chúng tôi!",
        title: "Đặt hàng thành công");
    notifyListeners();
  }
}
