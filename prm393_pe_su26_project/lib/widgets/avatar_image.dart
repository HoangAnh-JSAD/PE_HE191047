import 'package:flutter/material.dart';

const defaultAvatarPath = 'assets/default_avatar.jpg';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    super.key,
    this.avatar,
    this.radius = 24,
  });

  final String? avatar;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final value = avatar?.trim() ?? '';

    if (value.isEmpty) {
      return CircleAvatar(
        radius: radius,
        child: _buildAssetImage(defaultAvatarPath),
      );
    }

    if (value.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        child: ClipOval(
          child: Image.network(
            value,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _AvatarPlaceholder(radius: radius),
          ),
        ),
      );
    }

    if (value.startsWith('assets/')) {
      return CircleAvatar(
        radius: radius,
        child: _buildAssetImage(value),
      );
    }

    return CircleAvatar(
      radius: radius,
      child: _AvatarPlaceholder(radius: radius),
    );
  }

  Widget _buildAssetImage(String path) {
    return ClipOval(
      child: Image.asset(
        path,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _AvatarPlaceholder(radius: radius),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: radius,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
