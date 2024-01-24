import 'package:clean_architecture/page/app_login_page.dart';
import 'package:clean_architecture/page/app_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Page',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
          cardTheme: CardTheme(
            margin: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200, width: 1),
              borderRadius: BorderRadius.circular(15 + 7.5),
            ),
            color: Colors.white,
            elevation: 0,
          )),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == null) {
              return const AppLoginPage();
            } else {
              return const AppMainPage();
            }
          }
        },
      ),
    );
  }
}
