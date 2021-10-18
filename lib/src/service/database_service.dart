// import 'dart:io';
//
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:together2b/db/database/db.dart';
//
// class DataBaseService {
//   DataBase _database;
//
//   Future init() async {
//     // _database = await $FloorDataBase.databaseBuilder('xx.db').build();
//     Directory directory = await getApplicationDocumentsDirectory();
//     Hive.init(directory.path);
//
//     Hive.openBox('test');
//   }
//
//   DataBase get database => _database;
// }
