import 'package:flutter/material.dart';
import 'package:shop_shoe/ui/checkout/form_info.dart';

class CheckoutScreen extends StatelessWidget {
  static const routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xffE65829)),
      ),
      body: const Center(
        child: FormInfoCheckout(),
      ),
    );
  }
}
