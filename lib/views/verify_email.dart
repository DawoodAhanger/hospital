import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text('CareCrate'), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // center aligns the children vertically
          children: [
            const Text(
              "Please Verify your Email Address",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
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
