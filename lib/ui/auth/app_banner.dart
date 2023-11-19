import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 94.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.shade100,
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.blue,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Text(
        'Shop Shoe',
        style: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
          fontSize: 30,
          fontFamily: 'Anton',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
