import 'package:devaloop_login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
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
        child: SizedBox(
          width: 290,
          child: GoogleSignInButton(
            clientId: '',
            loadingIndicator: const CircularProgressIndicator(),
            onSignedIn: (UserCredential credential) {},
            onError: (exception) {},
            onCanceled: () {},
          ),
        ),
      ),
    );
  }
}
