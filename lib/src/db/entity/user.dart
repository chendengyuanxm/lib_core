import 'package:floor/floor.dart';

@Entity(tableName: 'User')
class User {
  @primaryKey
  final String userId;
  final String username;

  User(this.userId, this.username,);
}