export 'src/executor_stub.dart'
    if (dart.library.io) 'src/executor_io.dart'
    if (dart.library.html) 'src/executor_web.dart';
