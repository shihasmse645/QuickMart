import 'dart:math';
import 'package:quikmart/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl(this.sharedPreferences);

  @override
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (password.length > 6) {
      // Generate a unique token using DateTime.now + random number
      final now = DateTime.now().millisecondsSinceEpoch;
      final random = Random().nextInt(999999);
      final uniqueToken = 'token_${now}_$random';

      await sharedPreferences.setString('token', uniqueToken);
    } else {
      throw const ServerFailure('Invalid credentials');
    }
  }

  @override
Future<void> logout() async {
  // Removes the dummy token you saved during login
  await sharedPreferences.remove('token');
}
}
