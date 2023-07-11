import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:android_path_provider/android_path_provider.dart';

class FileUtil {

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print('local dir path: ${directory.path}');
    return directory.path;
  }

  static Future<String> get tempPath async {
    final directory = await getTemporaryDirectory();
    print('temp dir path: ${directory.path}');
    return directory.path;
  }

  static Future<String> get downloadPath async {
    String externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (err, st) {
        print('failed to get downloads path: $err, $st');

        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path??'';
      }
    } else {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path + '/download/';
    }
    return externalStorageDirPath;
  }
}