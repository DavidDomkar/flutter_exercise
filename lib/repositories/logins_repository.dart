import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/database.dart';

final loginsRepositoryProvider = Provider<ILoginsRepository>((ref) => throw UnimplementedError());

abstract class ILoginsRepository {
  Future<int> addLogin(String title, String username, String password);
  Stream<List<Login>> watchLogins();
  Stream<Login> watchLogin(int id);
}

class LoginsRepository extends ILoginsRepository {
  final FlutterSecureStorage storage;
  final Database database;

  LoginsRepository({required this.database, required this.storage});

  @override
  Future<int> addLogin(String title, String username, String password) async {
    final id = await database.insertLogin(LoginsCompanion.insert(title: title, username: username));

    await storage.write(key: 'login_$id', value: password);

    return id;
  }

  @override
  Stream<List<Login>> watchLogins() => database.watchLogins();

  @override
  Stream<Login> watchLogin(int id) {
    return database.watchLogin(id).asyncMap((login) async {
      final password = await storage.read(key: 'login_$id');

      return login.copyWith(password: password);
    });
  }
}
