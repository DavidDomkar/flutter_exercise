import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String loginTitle;
  final void Function() onDeletePressed;

  const DeleteDialog({Key? key, required this.loginTitle, required this.onDeletePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete $loginTitle'),
      content: const Text('Are you sure you want to delete this login?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            onDeletePressed();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
