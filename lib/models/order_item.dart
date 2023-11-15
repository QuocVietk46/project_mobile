import 'cart_item.dart';

class OrderItem {
  final String? id;
  final double amount;
  final String address;
  final String phone;
  final String name;
  final List<CartItem> products;
  final DateTime dateTime;

  int get productCount {
    return products.length;
  }

  OrderItem({
    this.id,
    required this.address,
    required this.phone,
    required this.name,
    required this.amount,
    required this.products,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith({
    String? id,
    String? address,
    String? phone,
    String? name,
    double? amount,
    List<CartItem>? products,
    DateTime? dateTime,
  }) {
    return OrderItem(
      id: id ?? this.id,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
