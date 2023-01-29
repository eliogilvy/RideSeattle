import '../classes/user.dart';
import 'database_helper.dart';

class UserDatabaseHelper {
  static String tableName = "User";

  static Future<void> createUser(User user) async {
    var database = await DatabaseHelper.instance.database;
    await database!.insert(tableName, user.toMap());
  }

  static Future<List<User>> getUsers() async {
    var database = await DatabaseHelper.instance.database;
    List<Map> list = await database!.rawQuery('SELECT * FROM $tableName');

    List<User> users = [];

    for (var element in list) {
      var user = User.fromMap(element);
      users.add(user);
    }
    return users;
  }

  static Future<void> updateUser(User user) async {
    var database = await DatabaseHelper.instance.database;
    await database!.update(
      tableName,
      user.toMap(),
      where: 'userId = ?',
      whereArgs: [user.userId],
    );
  }

  static Future<void> deleteUser(int id) async {
    var database = await DatabaseHelper.instance.database;
    await database!.delete(
      tableName,
      where: 'userId = ?',
      whereArgs: [id],
    );
  }
}
