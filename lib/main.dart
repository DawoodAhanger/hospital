



import 'package:flutter/material.dart';
import 'package:hospital/Services/Auth/auth_service.dart';
import 'package:hospital/views/constants/routes.dart';
import 'package:hospital/views/register_view.dart';
import 'package:hospital/views/verify_email.dart';
import 'package:hospital/views/constants/mainview.dart';
import 'package:hospital/Services/Auth/auth_user.dart';

import 'views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Homepage(),
      routes: {
        loginRoute: (context) => const Loginview(),
        registerRoute: (context) => const Registerview(),
        mainRoute: (context) => const Mainview(),
        verifyEmailroute:(context)=> const VerifyEmailView(),
      }));
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const Mainview();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const Loginview();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}


