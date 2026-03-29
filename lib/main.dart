// // ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; //utk inisialisasi firebase dan auth login
import 'package:provider/provider.dart'; // State management menggunakan Provider
import 'firebase_options.dart'; // File konfigurasi Firebase
import 'screens/Introduction_screen.dart';
import 'screens/signInPage.dart';
import 'screens/signUpPage.dart';
import 'screens/success.dart';
import 'screens/homePage.dart';
import 'services/auth_services.dart';
import 'models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'theme/app_theme.dart';

// ======================================= MAIN FUNCTION =======================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // proses pastikan Flutter siap sebelum async
//proses hubungin ke firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,  //konfigurasi dan hubungkan Firebase sesuai platform
    );
    print("Firebase initialized successfully");
  } catch (e, s) {
    // proses tangkap error Firebase agar app tidak crash jika Firebase gagal.
    print("Firebase initialization error: $e");
    print(s);
  }
// proses menjalankan widget utama aplikasi.
  runApp(MyApp());
}

// ==============================================
// WIDGET UTAMA APLIKASI
// ==============================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // proses setup provider untuk state global
        ChangeNotifierProvider(create: (_) => AuthServices()), // proses auth
        ChangeNotifierProvider(create: (_) => UserModel()), // proses simpan data user
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // hilangkan banner debug

        // THEME MODE .. gajadi pake theme!
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // defaultnya dark

                // =================== ROUTES ===================
        // proses daftar semua halaman / navigasi
        routes: {
          "/IntroPage": (context) => IntroductionPage(),
          "/SignInPage": (context) => SignInPage(),
          "/SignUpPage": (context) => SignUpPage(),
          "/SuccessPage": (context) => SuccessPage(),
          "/HomePage": (context) => HomePage(),
        },

        initialRoute: "/IntroPage",// proses set halaman pertama

               // =================== AUTO REDIRECT ===================
        // proses cek user sudah login atau belum
        home: SafeHome(),
      ),
    );
  }
}
// ==============================================
// SAFE HOME: proses cek user login
// ==============================================
/// Widget terpisah untuk StreamBuilder supaya release lebih aman
class SafeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      // proses monitoring login/logout user
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        try {
          // ================================= WAITING =================================
          if (snapshot.connectionState == ConnectionState.waiting) {
            // proses menunggu Firebase, tampil loading
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
            //kalo user sudah login ke homepage
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return SignInPage(); // user belum login, ke login page
          }
        } catch (e, s) {
          // proses tangkap error runtime supaya tidak crash
          print("StreamBuilder error: $e");
          print(s);
          return Scaffold(
            body: Center(
              child: Text("Terjadi kesalahan, coba restart app"),
            ),
          );
        }
      },
    );
  }
}



// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'screens/Introduction_screen.dart';
// import 'screens/signInPage.dart';
// import 'screens/signUpPage.dart';
// import 'screens/success.dart';
// import 'services/auth_services.dart';
// import 'models/user_models.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'screens/homePage.dart';
// import 'theme/app_theme.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthServices()),
//         ChangeNotifierProvider(create: (_) => UserModel()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,

//         //THEME MODE
//         theme: AppTheme.lightTheme,
//         darkTheme: AppTheme.darkTheme,
//         themeMode: ThemeMode.dark,//defaultnya dark dulu

//         // Routes
//         routes: {
//           "/IntroPage": (context) => IntroductionPage(),
//           "/SignInPage": (context) => SignInPage(),
//           "/SignUpPage": (context) => SignUpPage(),
//           "/SuccessPage": (context) => SuccessPage(),
//           "/HomePage": (context) => HomePage(),
//         },

//         initialRoute: "/IntroPage",

//         // Auto redirect jika user sudah login
//         home: StreamBuilder<firebase_auth.User?>(
//           stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return HomePage(); // Halaman setelah login
//             } else {
//               return SignInPage();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }