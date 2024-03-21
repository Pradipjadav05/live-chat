import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_page.dart';
import 'verify_email_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            /*
            * if verified email of current user then open chats screen else open email verification screen
            * */
            return const VerifyEmailPage();
          } else {
            /*
            * open login or register screen
            * */
            return const AuthPage();
          }
        },
      ),
    );
  }
}
