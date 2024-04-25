import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/page/loginreg.dart';
import 'package:mobile/page/mainscreen.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return HomePage();
            return HomePage();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}