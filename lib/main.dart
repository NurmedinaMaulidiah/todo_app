// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/Introduction_screen.dart';
import 'screens/signInPage.dart';
import 'screens/signUpPage.dart';
import 'screens/success.dart';
import 'services/auth_services.dart';
import 'models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'screens/homePage.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        //THEME MODE
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,//defaultnya dark dulu

        // Routes
        routes: {
          "/IntroPage": (context) => IntroductionPage(),
          "/SignInPage": (context) => SignInPage(),
          "/SignUpPage": (context) => SignUpPage(),
          "/SuccessPage": (context) => SuccessPage(),
          "/HomePage": (context) => HomePage(),
        },

        initialRoute: "/IntroPage",

        // Auto redirect jika user sudah login
        home: StreamBuilder<firebase_auth.User?>(
          stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage(); // Halaman setelah login
            } else {
              return SignInPage();
            }
          },
        ),
      ),
    );
  }
}