import 'package:flutter_test/flutter_test.dart';

import 'package:hospital/Services/Auth/Auth_exception.dart';
import 'package:hospital/Services/Auth/Auth_user.dart';
import 'package:hospital/Services/Auth/auth_provider.dart';

void main() {
  group('mockauthentication', () {
    final provider = MockAuthProvider();
    test('provider should not be initilied', () {
      expect(provider.isinitilized, false);
    });
    test('cannot logout if not initilized', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('should be able to initilize', () async {
      await provider.initialize();
      expect(provider.isinitilized, true);
    });
    test("user should be null after initilization", () async{
      expect(provider.currentUser, null);
    });
    test(
      'should be able to initilize in less than 2 sec',
      () async {
        await provider.initialize();
        expect(provider.isinitilized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('create user should delegate to login function', () async {
      await provider.initialize();
      final badEmailuser = provider.createUser(
        email: "foo@bar.com",
        password: "foo",
      );
      expect(
        badEmailuser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final badpasswordUser = provider.createUser(
        email: "someone@bar.com",
        password: "foobar",
      );
      expect(
        badpasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );
      final user = await provider.createUser(
        email: "aop@hj.com",
        password: "shbsh",
      );
      
      expect(provider.currentUser, user);
      expect(user!.isEmailVerified,false);
    });
    test('loggedIn user should be able to verified', () async{
      await provider.initialize();
      await provider.logIn(email: "email", password: "password");
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified,true);
    });
    test('user should be able to logout and login', () async {
      
      await provider.initialize();
      await provider.logIn(
        email: "email",
        password: "password",
      );
      
      final user = provider.currentUser;
      expect(user, isNotNull);
      
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isinitilized = false;
  bool get isinitilized => _isinitilized;
  

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    if (!isinitilized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isinitilized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isinitilized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException;
    if (password == "foobar") throw WrongPasswordAuthException();
    await Future.delayed(const Duration(seconds: 1));

    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isinitilized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user=null;
    
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isinitilized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
