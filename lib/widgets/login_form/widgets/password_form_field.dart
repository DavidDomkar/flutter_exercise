import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

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
  final LocalAuthentication _localAuthentication = LocalAuthentication();
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
              onPressed: () async {
                if (_obscureText && widget.readOnly && await _localAuthentication.canCheckBiometrics) {
                  try {
                    final authenticated = await _localAuthentication.authenticate(localizedReason: 'Please authenticate to show password!');

                    if (!authenticated) {
                      return;
                    }
                  } catch (_) {}
                }

                setState(() => _obscureText = !_obscureText);
              },
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            ),
            if (widget.readOnly)
              IconButton(
                onPressed: () async {
                  if (await _localAuthentication.canCheckBiometrics) {
                    try {
                      final authenticated = await _localAuthentication.authenticate(localizedReason: 'Please authenticate to copy password!');

                      if (!authenticated) {
                        return;
                      }
                    } catch (_) {}
                  }

                  widget.onCopyPressed?.call();
                },
                icon: const Icon(Icons.copy),
              ),
          ],
        ),
      ),
    );
  }
}
