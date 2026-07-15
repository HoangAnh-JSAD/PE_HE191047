import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../repositories/sqlite_user_repository.dart';
import '../repositories/in_memory_user_repository.dart';

part 'user_view_model.g.dart';

class UserState {
  final List<UserModel> items;
  final bool isLoading;

  UserState({
    this.items = const [],
    this.isLoading = false,
  });

  UserState copyWith({
    List<UserModel>? items,
    bool? isLoading,
  }) {
    return UserState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  if (kIsWeb) {
    return InMemoryUserRepository();
  }
  return SqliteUserRepository();
}

@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  UserState build() {
    loadUsers();
    return UserState(isLoading: true);
  }

  Future<void> loadUsers() async {
    final repository = ref.read(userRepositoryProvider);
    final users = await repository.getUsers();
    state = state.copyWith(items: users, isLoading: false);
  }

  Future<void> addUser({
    required String fullName,
    required String email,
    required String avatar,
  }) async {
    final repository = ref.read(userRepositoryProvider);
    final newUser = UserModel(
      id: 0, // SQLite will handle autoincrement
      fullName: fullName,
      email: email,
      avatar: avatar,
    );
    await repository.addUser(newUser);
    await loadUsers();
  }

  Future<void> updateUser(UserModel user) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.updateUser(user);
    await loadUsers();
  }

  Future<void> deleteUser(int id) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.deleteUser(id);
    await loadUsers();
  }
}
