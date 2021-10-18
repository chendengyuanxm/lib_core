import 'package:path_provider/path_provider.dart';

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
}