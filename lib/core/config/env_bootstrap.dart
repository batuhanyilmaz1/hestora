import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/app_logger.dart';
import 'env_merge_stub.dart'
    if (dart.library.io) 'env_merge_io.dart' as env_merge;

Future<void> loadAppDotEnv() async {
  try {
    await dotenv.load(
      fileName: '.env',
      mergeWith: env_merge.platformEnvironmentForDotenv(),
      isOptional: true,
    );
  } catch (e, st) {
    appLog('dotenv primary load failed, using empty file + platform merge', e, st);
    dotenv.testLoad(
      fileInput: '',
      mergeWith: env_merge.platformEnvironmentForDotenv(),
    );
  }
}
