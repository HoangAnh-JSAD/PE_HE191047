import '../models/user.dart';
import 'database_helper.dart';
import 'user_repository.dart';

class SqliteUserRepository implements UserRepository {
  @override
  Future<List<UserModel>> getUsers() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('users');
    return result.map((json) => UserModel.fromMap(json)).toList();
  }

  @override
  Future<void> addUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('users', {
      'fullName': user.fullName,
      'email': user.email,
      'avatar': user.avatar,
    });
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
