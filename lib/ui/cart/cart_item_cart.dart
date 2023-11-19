import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../shared/dialog_utils.dart';
import 'cart_manager.dart';

class CartItemCart extends StatefulWidget {
  final String productId;
  final CartItem cartItem;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const CartItemCart({
    required this.productId,
    required this.cartItem,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
    super.key,
  });
  @override
  CartItemCartState createState() => CartItemCartState();
}

class CartItemCartState extends State<CartItemCart> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.cartItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showConfirmDialog(context, 'Xác nhận',
            'Bạn có chắc muốn xoá sản phẩm khỏi giỏ hàng?');
      },
      onDismissed: (direction) {
        context.read<CartManager>().removeSingleItem(widget.cartItem.id);
      },
      child: buildItemCart(),
    );
  }

  Widget buildItemCart() {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: Image.network(
                  widget.cartItem.imageUrl,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    widget.cartItem.title,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                subtitle: Text(
                  'Total: \$${(widget.cartItem.price * widget.cartItem.quantity)}',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Text('${widget.cartItem.quantity} x'),
              ),
              if (isExpanded)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (widget.cartItem.quantity > 1) {
                            context
                                .read<CartManager>()
                                .decreaseItem(widget.cartItem.id);
                          }
                        });
                      },
                    ),
                    Text('${widget.cartItem.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          context
                              .read<CartManager>()
                              .increaseItem(widget.cartItem.id);
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
