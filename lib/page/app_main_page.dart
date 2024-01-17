import 'package:devaloop_main_page/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  late bool _isLoggingOut;

  @override
  void initState() {
    _isLoggingOut = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggingOut
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : MainPage(
            appName: 'Clean Architecture',
            appIcon: Image.asset(
              'assets/images/app-logo.png',
              height: 16,
              width: 16,
            ),
            onTapAppIconAndName: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Clean Architecture'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'Build app with clean architecture using packages from devaloop.com'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop('Close');
                        },
                      ),
                    ],
                  );
                },
              );
            },
            userInfo: FirebaseAuth.instance.currentUser!.email!,
            onTapUserInfo: () async {
              var result = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                        'Are you sure you want to log out of this account?'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(FirebaseAuth.instance.currentUser!.email!),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop('No');
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop('Yes');
                        },
                      ),
                    ],
                  );
                },
              );

              if (!context.mounted) return;

              if (result != null) {
                if (result == 'Yes') {
                  setState(() {
                    _isLoggingOut = true;
                  });

                  await signOut();
                }
              }
            },
            mainMenus: const [
              MainMenu(
                text: 'Member',
                icon: Icon(Icons.people),
                content: Text('Content for Member'),
              ),
              MainMenu(
                text: 'Hobbies',
                icon: Icon(Icons.spoke),
                content: Text('Content for Hobbies'),
              ),
            ],
          );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
