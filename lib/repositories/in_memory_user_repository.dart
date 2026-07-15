import '../models/user.dart';
import 'user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  final List<UserModel> _users = <UserModel>[
    const UserModel(
      id: 1,
      fullName: 'Nguyen Van An',
      email: 'an.nguyen@gmail.com',
      avatar: 'assets/default_avatar.jpg',
    ),
    const UserModel(
      id: 2,
      fullName: 'Tran Thi Binh',
      email: 'binh.tran@gmail.com',
      avatar: 'assets/default_avatar.jpg',
    ),
  ];

  @override
  Future<List<UserModel>> getUsers() async {
    return List<UserModel>.from(_users);
  }

  @override
  Future<void> addUser(UserModel user) async {
    final newId = _users.isEmpty ? 1 : _users.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    _users.add(user.copyWith(id: newId));
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    _users.removeWhere((u) => u.id == id);
  }
}
