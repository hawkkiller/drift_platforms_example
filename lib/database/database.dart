import 'package:drift/drift.dart';
import 'package:drift_platforms/main.dart';

part 'database.g.dart';

@DriftDatabase(include: {
  'tables/categories.drift',
  'tables/users.drift',
})
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.exec);

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // add new table here from ver. 2
          // previously, there was an object notation for
          m.addColumn(db.users, db.users.email);
          m.createTable(db.categories);
        }
      });

  @override
  int get schemaVersion => 2;
}
