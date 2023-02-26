import 'package:hospital/Services/Auth/Auth_user.dart';
import 'package:hospital/Services/Auth/auth_exception.dart';

abstract class AuthProvider{
  AuthUser? get currentUser;
  Future<AuthUser?> logIn({
    required String email,
    required String password
  });
  Future<AuthUser?> createUser({
    required String email,
    required String password
  });
  Future<void>logout();
  Future<void>sendEmailVerification();
  
}