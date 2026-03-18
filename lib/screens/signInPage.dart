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
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mohon isi email dan password"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();

    setState(() => _loading = true);

    try {
      var user = await Provider.of<AuthServices>(context, listen: false)
          .signIn(email, password);

      if (user != null) {
          _showLoginSuccessDialog();
        }
      } catch (e) {
        if (e.toString().contains("user-not-found")) {
          _showUserNotFoundDialog();
        } else if (e.toString().contains("wrong-password")) {
          _showWrongPasswordDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login gagal: $e")),
          );
        }
      }
      setState(() => _loading = false);
    }

    //berhasil login
    void _showLoginSuccessDialog() {

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        title: Text("Login Berhasil"),
        content: Text("Selamat datang kembali!"),
        actions: [

          TextButton(
            onPressed: () {

              Navigator.pop(context);

              Navigator.pushReplacementNamed(context, "/HomePage");

            },
            child: Text("OK"),
          )

        ],
      );

    },
  );
}

//email ga terdaftar
void _showUserNotFoundDialog() {

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        title: Text("Akun Tidak Ditemukan"),
        content: Text("Email belum terdaftar. Silakan daftar terlebih dahulu."),
        actions: [

          TextButton(
            onPressed: () {

              Navigator.pop(context);

              Navigator.pushReplacementNamed(context, "/SignUpPage");

            },
            child: Text("Daftar"),
          )

        ],
      );

    },
  );
}

//pw salah
void _showWrongPasswordDialog() {

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        title: Text("Password Salah"),
        content: Text("Password yang Anda masukkan salah."),
        actions: [

          TextButton(
            onPressed: () {

              Navigator.pop(context);

            },
            child: Text("Coba Lagi"),
          )

        ],
      );

    },
  );
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
              margin: EdgeInsets.only(top: 200), //atur jarak atas box radient
              height: MediaQuery.of(context).size.height, //atur box gradient
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
                    SizedBox(height: tinggi * 0.05), //atur jarak atas tulisan sign in
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email wajib diisi";
                        }

                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "Format email tidak valid";
                        }

                        return null;
                      }
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password wajib diisi";
                        }

                        return null;
                      }
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
                        "Don’t have an Account? Sign Up",
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