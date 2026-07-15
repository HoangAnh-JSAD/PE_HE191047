import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/avatar_image.dart';

class UserDetailScreen extends StatelessWidget {
  UserDetailScreen({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Detail')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: AvatarImage(
                  key: Key('detail_avatar'),
                  avatar: user.avatar,
                  radius: 64,
                ),
              ),
              SizedBox(height: 24),
              Text('ID: ${user.id}', key: Key('detail_id')),
              SizedBox(height: 12),
              Text('Họ và tên'),
              SizedBox(height: 4),
              Text(user.fullName, key: Key('detail_fullname')),
              SizedBox(height: 12),
              Text('Email'),
              SizedBox(height: 4),
              Text(user.email, key: Key('detail_email')),
            ],
          ),
        ),
      ),
    );
  }
}
