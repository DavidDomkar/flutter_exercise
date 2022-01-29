import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormViewModel extends ChangeNotifier {
  final Reader read;
  final GlobalKey<FormState> _formKey;

  bool _loading;

  String title;
  String username;
  String password;

  FormViewModel(this.read)
      : _formKey = GlobalKey<FormState>(),
        _loading = false,
        title = '',
        username = '',
        password = '';

  String? fieldValidator(String? value) {
    value = value?.trim();
    return value == null || value.isEmpty ? 'This field is required!' : null;
  }

  GlobalKey<FormState> get formKey => _formKey;

  bool get loading => _loading;
}
