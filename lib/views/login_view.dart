import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:hospital/views/constants/routes.dart';

import '../firebase_options.dart';
import 'constants/showerrordialog.dart';

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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
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
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainRoute, (_) => false);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                await showErrorDialog(context, "user not found");
                              } else if (e.code == "wrong-password") {
                                await showErrorDialog(context, "Wrong Password");
                              }
                              else {
                                await showErrorDialog(context, "Error:${e.code}");
                              }
                            }catch(e){
                              await showErrorDialog
                              (context, e.toString());
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
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
