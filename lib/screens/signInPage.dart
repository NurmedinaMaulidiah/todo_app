// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      // Panggil AuthServices
      var user = await Provider.of<AuthServices>(context, listen: false)
          .signIn(email, password);

      if (user != null) {
        // Update UserModel
        Provider.of<UserModel>(context, listen: false).setUser(
          fullName: user.fullName,
          username: user.username,
          email: user.email,
        );

        // Pindah ke SuccessPage
        Navigator.pushReplacementNamed(context, "/SuccessPage");
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Color(0xFF8AB0AB),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
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
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : handleSignIn,
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
                      : Text("Sign In"),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/SignUpPage");
                },
                child: Text("Belum punya akun? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}