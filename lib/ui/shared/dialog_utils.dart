import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
    BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Huỷ'),
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
        ),
        TextButton(
          child: const Text('Vâng'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    ),
  );
}

Future<void> showErrorDialog(BuildContext context, String message,
    {String title = 'Có lỗi xảy ra!'}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Đóng'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}

Future<void> showThanksDialog(BuildContext context, String message,
    {required String title}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cảm ơn bạn!'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Không có chi :))'),
          onPressed: () {
            Navigator.of(ctx).pushNamed('/');
          },
        )
      ],
    ),
  );
}
