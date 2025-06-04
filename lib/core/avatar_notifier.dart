import 'package:flutter/material.dart';

class AvatarNotifier {
  static final ValueNotifier<String> avatarPath = ValueNotifier<String>(
    'assets/images/default_avatar.jpeg',
  );
}
