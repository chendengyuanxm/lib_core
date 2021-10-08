import 'package:floor/floor.dart';
import 'package:lib_core/db/dao/user_dao.dart';
import 'package:lib_core/db/entity/user.dart';

part 'db.g.dart';

@Database(version: 1, entities: [User])
abstract class DataBase extends FloorDatabase {
  UserDao get userDao;
}
