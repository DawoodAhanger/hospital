import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hospital/views/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('CareCrate'), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // center aligns the children vertically
          children: [
            const Text(
              "We have alredy send you an email.Please open it to verify your Email",
              style: TextStyle(
                  fontSize: 20, 
                  color: Color.fromARGB(255, 170, 225, 172),
                  letterSpacing: 1.5,
                  height:1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              "If you have not recieved email verification. Press the button below.",
              style: TextStyle(fontSize: 15,
              letterSpacing: 1.5,
              height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send me an email Verification"),
            ),
            ElevatedButton(onPressed:()async{
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            }, child: const Text("Restart"))
          ],
        ),
      ),
    );
  }
}
