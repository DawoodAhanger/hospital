import 'package:flutter/material.dart';
import 'package:hospital/Services/Auth/Auth_exception.dart';


import 'package:hospital/views/constants/routes.dart';

import '../Services/Auth/auth_service.dart';

import 'package:hospital/views/constants/showerrordialog.dart';



class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterState();
}

class _RegisterState extends State<Registerview> {
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
            title: const Text('CareCrate'), backgroundColor: Colors.green),
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase().createUser(
                            email: email,
                            password: password,
                          );
                          AuthService.firebase().sendEmailVerification();

                          Navigator.of(context).pushNamed(verifyEmailroute);
                        } on WeakPasswordAuthException {
                          await showErrorDialog(
                            context,
                            "weak password",
                          );
                        } on EmailAlreadyInUseAuthException {
                          await showErrorDialog(
                            context,
                            "Email already in use",
                          );
                        } on InvalidEmailAuthException {
                          await showErrorDialog(
                            context,
                            "This is an invalid email",
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            "Failed to Register",
                          );
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate to login screen
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: const Text('Already registered? Login here'),
                    ),
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ));
  }
}
