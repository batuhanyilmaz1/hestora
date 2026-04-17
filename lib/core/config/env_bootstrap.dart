import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_merge_stub.dart'
    if (dart.library.io) 'env_merge_io.dart' as env_merge;

Future<void> loadAppDotEnv() async {
  await dotenv.load(
    fileName: '.env',
    mergeWith: env_merge.platformEnvironmentForDotenv(),
    isOptional: false,
  );
}
