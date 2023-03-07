import 'package:flutter/material.dart';
import 'package:hospital/Services/Auth/Auth_exception.dart';


import 'package:hospital/views/constants/routes.dart';

import '../Services/Auth/auth_service.dart';

import 'package:hospital/views/constants/showerrordialog.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  late final TextEditingController _email;

  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();

    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareCrate'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Enter your email'),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;

                            try {
                              await AuthService.firebase().logIn(
                                email: email,
                                password: password,
                              );
                              final user = AuthService.firebase().currentUser;
                              if (user?.isEmailVerified ?? false) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainRoute,
                                  (_) => false,
                                );
                              } else {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  verifyEmailroute,
                                  (_) => false,
                                );
                              }
                            } on UserNotFoundAuthException {
                              print("user not Found");
                              await showErrorDialog(
                                context,
                                'user not found',
                              );
                            } on WrongPasswordAuthException {
                              await showErrorDialog(
                                context,
                                'Wrong Password',
                              );
                            } on GenericAuthException {
                              await showErrorDialog(
                                context,
                                'Authentication Error',
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          child: const Text(
                            'Login ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to the registration screen
                            Navigator.pushNamed(context, registerRoute);
                          },
                          child: const Text(" Register Here"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            default:
              // Show a loading spinner until the future completes
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
