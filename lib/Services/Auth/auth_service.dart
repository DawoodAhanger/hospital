import 'package:hospital/Services/Auth/Auth_user.dart';
import 'package:hospital/Services/Auth/auth_exception.dart';
import 'package:hospital/Services/Auth/auth_provider.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider;
  const AuthService(this.provider);

  @override
  Future<AuthUser?> createUser({required String email, required String password}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => throw UnimplementedError();

  @override
  Future<AuthUser?> logIn({required String email, required String password}) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

}