import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final String? initialValue;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onCopyPressed;
  final bool readOnly;

  const PasswordFormField({
    Key? key,
    this.initialValue,
    this.textInputAction,
    this.autovalidateMode,
    this.validator,
    this.onChanged,
    this.onCopyPressed,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: 'Password',
        alignLabelWithHint: true,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => setState(() => _obscureText = !_obscureText),
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            ),
            if (widget.readOnly)
              IconButton(
                onPressed: widget.onCopyPressed,
                icon: const Icon(Icons.copy),
              ),
          ],
        ),
      ),
    );
  }
}
