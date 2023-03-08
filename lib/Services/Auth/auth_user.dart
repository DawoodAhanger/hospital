

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  
  const AuthUser({required this.isEmailVerified});
  
  factory AuthUser.fromFirebase(User user) =>
    AuthUser( isEmailVerified: user.emailVerified);
}
