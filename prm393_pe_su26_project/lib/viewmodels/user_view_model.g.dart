// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'dea42d497be8eb06ebba6f54c74df7abd301b1bb';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$userViewModelHash() => r'3c2d9dde7691dcafec80d053f76c7567b0058fcc';

/// See also [UserViewModel].
@ProviderFor(UserViewModel)
final userViewModelProvider =
    AutoDisposeNotifierProvider<UserViewModel, UserState>.internal(
  UserViewModel.new,
  name: r'userViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserViewModel = AutoDisposeNotifier<UserState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
