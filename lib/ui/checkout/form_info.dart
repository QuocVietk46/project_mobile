import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shoe/ui/cart/cart_manager.dart';

import 'package:shop_shoe/ui/orders/orders_manager.dart';
import 'package:shop_shoe/ui/shared/dialog_utils.dart';

class FormInfoCheckout extends StatefulWidget {
  const FormInfoCheckout({super.key});

  @override
  MyFormState createState() => MyFormState();
}

class MyFormState extends State<FormInfoCheckout> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 20, 30.0, 40.0),
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const Text(
                    'Nhập thông tin đơn hàng',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: 'Tên người nhận'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên của bạn!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLines: null,
                    controller: _addressController,
                    decoration:
                        const InputDecoration(labelText: 'Địa chỉ nhận hàng'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ nhận hàng!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Số điện thoại'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE65829),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, process the data
                    String name = _nameController.text;
                    String address = _addressController.text;
                    String phone = _phoneController.text;

                    context.read<OrdersManager>().addOrder(
                        context,
                        context.read<CartManager>().products,
                        context.read<CartManager>().totalAmount,
                        name,
                        address,
                        phone);
                    context.read<CartManager>().clear();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
