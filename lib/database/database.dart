import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@UseRowClass(Login)
class Logins extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get username => text()();
}

@CopyWith()
class Login {
  final int id;
  final String title;
  final String username;
  final String password;

  Login({required this.id, required this.title, required this.username, this.password = ''});
}

@DriftDatabase(tables: [Logins])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertLogin(LoginsCompanion entry) {
    return into(logins).insert(entry);
  }

  Stream<List<Login>> watchLogins() => select(logins).watch();

  Stream<Login> watchLogin(int id) => (select(logins)..where((login) => login.id.equals(id))).watchSingle();
}
