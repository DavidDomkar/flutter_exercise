import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool loading;

  const SubmitButton({Key? key, required this.onPressed, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Center(
        child: loading
            ? const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
            : Text('Add login'),
      ),
      onPressed: loading ? null : onPressed,
    );
  }
}
