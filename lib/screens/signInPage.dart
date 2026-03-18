// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/auth_services.dart';
// import '../models/user_models.dart';

// class SignInPage extends StatefulWidget {
//   @override
//   _SignInPageState createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _controllerEmail = TextEditingController();
//   final TextEditingController _controllerPassword = TextEditingController();
//   bool _loading = false;

//   @override
//   void dispose() {
//     _controllerEmail.dispose();
//     _controllerPassword.dispose();
//     super.dispose();
//   }

//   void handleSignIn() async {
//     if (!_formKey.currentState!.validate()) return;

//     final email = _controllerEmail.text.trim();
//     final password = _controllerPassword.text.trim();

//     setState(() => _loading = true);

//     try {
//       // Panggil AuthServices
//       var user = await Provider.of<AuthServices>(context, listen: false)
//           .signIn(email, password);

//       if (user != null) {
//         // Update UserModel
//         Provider.of<UserModel>(context, listen: false).setUser(
//           fullName: user.fullName,
//           username: user.username,
//           email: user.email,
//         );

//         // Pindah ke SuccessPage
//         Navigator.pushReplacementNamed(context, "/HomePage");
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Login gagal! Periksa email dan password.")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Terjadi kesalahan: $e")),
//       );
//     }

//     setState(() => _loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Sign In"),
//       //   backgroundColor: Color(0xFF8AB0AB),
//       // ),
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _controllerEmail,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(labelText: "Email"),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Masukkan email" : null,
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _controllerPassword,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: "Password"),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Masukkan password" : null,
//               ),
//               SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _loading ? null : handleSignIn,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF8AB0AB),
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   child: _loading
//                       ? SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : Text("Sign In"),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/SignUpPage");
//                 },
//                 child: Text("Belum punya akun? Sign Up"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/theme/app_theme.dart';
import '../services/auth_services.dart';
import '../models/user_models.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  void handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();

    setState(() => _loading = true);

    try {
      var user = await Provider.of<AuthServices>(context, listen: false)
          .signIn(email, password);

      if (user != null) {
        Provider.of<UserModel>(context, listen: false).setUser(
          fullName: user.fullName,
          username: user.username,
          email: user.email,
        );
        Navigator.pushReplacementNamed(context, "/HomePage");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login gagal! Periksa email dan password.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;
    final tinggi = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: lebar * 0.08),
            child: Container(
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.only(top: 200) ,
              height: MediaQuery.of(context).size.height, // 80% tinggi layar
             decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
                AppTheme.gradientGreen,          // hijau pastel tema utama
                AppTheme.darkBg, // lebih gelap untuk transisi
              ],
            ),
          ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: tinggi * 0.05),
                    Text(
                      "Sign In",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: lebar * 0.07),
                    ),
                    SizedBox(height: tinggi * 0.04),
                    TextFormField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Masukkan email" : null,
                    ),
                    SizedBox(height: tinggi * 0.05),
                    TextFormField(
                      controller: _controllerPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Masukkan password"
                          : null,
                    ),
                    SizedBox(height: tinggi * 0.04),
                    SizedBox(
                      width: double.infinity,
                      height: tinggi * 0.065,
                      child: ElevatedButton(
                        onPressed: _loading ? null : handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _loading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Sign In",
                                style: TextStyle(fontSize: lebar * 0.045),
                              ),
                      ),
                    ),
                    SizedBox(height: tinggi * 0.02),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/SignUpPage");
                      },
                      child: Text(
                        "Belum punya akun? Sign Up",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: lebar * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}