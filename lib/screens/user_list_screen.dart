import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../viewmodels/user_view_model.dart';
import '../widgets/avatar_image.dart';
import 'user_detail_screen.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  UserModel? _editingUser;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Manager'),
        actions: [
          IconButton(
            onPressed: _cancelEdit,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final isTablet = constraints.maxWidth >= 600;
            final useTwoColumns = isLandscape || isTablet;

            return Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  _buildForm(),
                  SizedBox(height: 12),
                  Expanded(
                    child: _buildUserList(
                      users: state.items,
                      useTwoColumns: useTwoColumns,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: Key('input_fullname'),
            controller: _fullNameController,
            decoration: InputDecoration(
              labelText: 'Họ và tên',
              hintText: 'Nhập họ và tên',
              border: OutlineInputBorder(),
            ),
            validator: _validateFullName,
          ),
          SizedBox(height: 8),
          TextFormField(
            key: Key('input_email'),
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'example@gmail.com',
              border: OutlineInputBorder(),
            ),
            validator: _validateEmail,
          ),
          SizedBox(height: 8),
          TextFormField(
            key: Key('input_avatar'),
            controller: _avatarController,
            decoration: InputDecoration(
              labelText: 'Avatar',
              hintText: defaultAvatarPath,
              border: OutlineInputBorder(),
            ),
            validator: _validateAvatar,
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  key: Key('btn_add_user'),
                  onPressed: _handleSubmit,
                  child:
                      Text(_editingUser == null ? 'ADD USER' : 'UPDATE USER'),
                ),
              ),
              if (_editingUser != null) ...<Widget>[
                SizedBox(width: 8),
                OutlinedButton(
                  key: Key('btn_cancel_edit'),
                  onPressed: _cancelEdit,
                  child: Text('CANCEL'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserList({
    required List<UserModel> users,
    required bool useTwoColumns,
  }) {
    return GridView.builder(
      key: Key('user_list'),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: useTwoColumns ? 2 : 1,
        mainAxisExtent: 104,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: Key('user_item_${user.id}'),
            onTap: () => _openDetail(user),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  AvatarImage(
                    key: Key('user_item_avatar_${user.id}'),
                    avatar: user.avatar,
                    radius: 22,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: Key('user_item_edit_${user.id}'),
                    icon: Icon(Icons.edit),
                    onPressed: () => _startEdit(user),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Sửa',
                  ),
                  IconButton(
                    key: Key('user_item_delete_${user.id}'),
                    icon: Icon(Icons.delete),
                    onPressed: () => _confirmDelete(user),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Xoá',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Họ và tên không được để trống';
    }
    if (value.length < 2) {
      return 'Họ và tên tối thiểu 2 ký tự';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không đúng định dạng';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không đúng định dạng';
    }
    return null;
  }

  String? _validateAvatar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng chọn ảnh đại diện';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text;
      final email = _emailController.text;
      final avatar = _avatarController.text;

      if (_editingUser == null) {
        await ref.read(userViewModelProvider.notifier).addUser(
              fullName: fullName,
              email: email,
              avatar: avatar,
            );
      } else {
        await ref.read(userViewModelProvider.notifier).updateUser(
              _editingUser!.copyWith(
                fullName: fullName,
                email: email,
                avatar: avatar,
              ),
            );
      }
      _cancelEdit();
    } else {
      if (_editingUser != null) {
        _fullNameController.clear();
        _avatarController.clear();
        setState(() {});
      }
    }
  }

  void _startEdit(UserModel user) {
    setState(() {
      _editingUser = user;
      _fullNameController.text = user.fullName;
      _emailController.text = user.email;
      _avatarController.text = user.avatar;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingUser = null;
      _fullNameController.clear();
      _emailController.clear();
      _avatarController.clear();
      _formKey.currentState?.reset();
    });
  }

  Future<void> _confirmDelete(UserModel user) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: Key('delete_confirm_dialog'),
        title: Text('Xác nhận xoá'),
        content: Text('Bạn có chắc chắn muốn xoá ${user.fullName}?'),
        actions: [
          TextButton(
            key: Key('btn_cancel_delete'),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Huỷ'),
          ),
          TextButton(
            key: Key('btn_confirm_delete'),
            onPressed: () {
              ref.read(userViewModelProvider.notifier).deleteUser(user.id);
              Navigator.of(context).pop();
            },
            child: Text('Xoá'),
          ),
        ],
      ),
    );
  }

  void _openDetail(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UserDetailScreen(user: user),
      ),
    );
  }
}
