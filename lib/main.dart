import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/views/register_view.dart';

import 'firebase_options.dart';
import 'views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const Homepage(),
    routes:{
      '/login/':(context) => const Loginview(),
      '/register/':(context) => const Registerview()
    }
  ));
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              /*  final user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified ?? false) {
                  return const Text("Done");
                } else {
                  return const   VerifyEmailView();
                } */
                return const Loginview();
              default:
                return const Text("Loading....");
            }
          },
        );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // center aligns the children vertically
          children: [
            const Text(
              "Please Verify your Email Address",
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
              onPressed: () async{
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send me an email Verification"),
            )
          ],
        ),
      ),
    );
      

    
      
      
    
  }
}
