import 'package:drift/drift.dart';

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get password => text()();
}

@DriftDatabase(tables: [Users])
class AppDatabase extends _$MyDatabase {
  AppDatabase(super.exec);

  @override
  int get schemaVersion => 1;
}
