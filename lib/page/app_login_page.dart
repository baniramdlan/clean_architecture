import 'package:devaloop_login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppLoginPage extends StatelessWidget {
  const AppLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      appIcon: Image.asset(
        'assets/images/app-logo.png',
        height: 64,
        width: 64,
      ),
      appName: 'Clean Architecture',
      appTagline: 'Build App With Clean Architecture',
      loginForm: Center(
        child: FilledButton(
          onPressed: () async {
            await signInWithGoogle();
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com',
      'prompt': 'select_account',
    });

    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }
}
