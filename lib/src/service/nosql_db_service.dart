import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class NoSqlDataBaseService {

  Future init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
}