import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/logins_repository.dart';

class FormViewModel extends ChangeNotifier {
  final Reader read;
  final GlobalKey<FormState> _formKey;

  bool _loading;

  String title;
  String username;
  String password;

  ILoginsRepository get _loginsRepository => read(loginsRepositoryProvider);

  FormViewModel(this.read)
      : _formKey = GlobalKey<FormState>(),
        _loading = false,
        title = '',
        username = '',
        password = '';

  String? emptyFieldValidator(String? value) {
    value = value?.trim();
    return value == null || value.isEmpty ? 'This field is required!' : null;
  }

  Future<void> submit() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    _loading = true;
    notifyListeners();

    await _loginsRepository.addLogin(title, username, password);
  }

  GlobalKey<FormState> get formKey => _formKey;

  bool get loading => _loading;
}
