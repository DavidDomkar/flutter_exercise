import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/database.dart';
import 'repositories/logins_repository.dart';

final loginProvider = StreamProvider.autoDispose.family<Login?, int>((ref, id) {
  final loginsRepository = ref.watch(loginsRepositoryProvider);

  return loginsRepository.watchLogin(id);
});

final loginsProvider = StreamProvider.autoDispose<List<Login>>((ref) {
  final loginsRepository = ref.watch(loginsRepositoryProvider);

  return loginsRepository.watchLogins();
});
