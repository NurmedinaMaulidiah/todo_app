// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';
import '../models/user_models.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPw = TextEditingController();

  @override
  void dispose() {
    _controllerFullName.dispose();
    _controllerUserName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPw.dispose();
    super.dispose();
  }

  void handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final fullName = _controllerFullName.text.trim();
    final username = _controllerUserName.text.trim();
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();
    final confirmPassword = _controllerConfirmPw.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password dan Confirm Password tidak sama")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Memanggil AuthServices untuk daftar user di Firebase
      var newUser = await Provider.of<AuthServices>(context, listen: false)
          .signUp(fullName, username, email, password, confirmPassword);

      if (newUser != null) {
        // Update UserModel
        Provider.of<UserModel>(context, listen: false).setUser(
          fullName: fullName,
          username: username,
          email: email,
        );

        // Navigasi ke SuccessPage
        Navigator.pushReplacementNamed(context, "/SuccessPage");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mendaftar! Coba lagi.")),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Color(0xFF8AB0AB),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _controllerFullName,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Masukkan nama lengkap" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _controllerUserName,
                decoration: InputDecoration(labelText: "Username"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Masukkan username" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _controllerEmail,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || value.isEmpty ? "Masukkan email" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _controllerPassword,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Masukkan password" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _controllerConfirmPw,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirm Password"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Konfirmasi password" : null,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8AB0AB),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text("Sign Up"),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/SignInPage");
                },
                child: Text("Sudah punya akun? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}