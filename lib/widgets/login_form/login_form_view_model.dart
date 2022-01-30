import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../repositories/logins_repository.dart';

class LoginFormViewModel extends ChangeNotifier {
  final Reader read;
  final Login? login;

  final GlobalKey<FormState> _formKey;

  bool _loading;

  String title;
  String username;
  String password;

  ILoginsRepository get _loginsRepository => read(loginsRepositoryProvider);

  LoginFormViewModel(this.read, this.login)
      : _formKey = GlobalKey<FormState>(),
        _loading = false,
        title = login?.title ?? '',
        username = login?.username ?? '',
        password = login?.password ?? '';

  String? emptyFieldValidator(String? value) {
    value = value?.trim();
    return value == null || value.isEmpty ? 'This field is required!' : null;
  }

  Future<int?> submit() async {
    if (_loading) return null;
    if (!_formKey.currentState!.validate()) return null;

    _loading = true;
    notifyListeners();

    int id;

    if (login != null) {
      await _loginsRepository.editLogin(login!.id, title, username, password);
      id = login!.id;
    } else {
      id = await _loginsRepository.addLogin(title, username, password);
    }

    return id;
  }

  GlobalKey<FormState> get formKey => _formKey;

  bool get loading => _loading;
}
