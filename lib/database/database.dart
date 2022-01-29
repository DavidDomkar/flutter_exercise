import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

class Logins extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get username => text()();
}

@DriftDatabase(tables: [Logins])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> addLogin(LoginsCompanion entry) {
    return into(logins).insert(entry);
  }

  Stream<List<Login>> watchAllLogins() => select(logins).watch();

  Stream<Login> watchLogin(int id) => (select(logins)..where((login) => login.id.equals(id))).watchSingle();
}
