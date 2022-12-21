import 'dart:async';

import 'package:drift/web.dart';
import 'package:drift_platforms/database/database.dart';

FutureOr<AppDatabase> configureDb() async {
  return AppDatabase(
    WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported('db'),
    ),
  );
}
