import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/logins_repository.dart';

class DetailViewModel {
  final Reader read;

  ILoginsRepository get _loginsRepository => read(loginsRepositoryProvider);

  DetailViewModel(this.read);

  Future<void> deleteLogin(int id) async {
    await _loginsRepository.deleteLogin(id);
  }
}
