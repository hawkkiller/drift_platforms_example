import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_platforms/database/database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

FutureOr<AppDatabase> configureDb() {
  final db = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
  return AppDatabase(db);
}
