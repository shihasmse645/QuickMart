
import 'package:quikmart/features/auth/domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
