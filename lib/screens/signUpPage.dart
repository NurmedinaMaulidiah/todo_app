// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/theme/app_theme.dart';
import '../services/auth_services.dart';
import '../models/user_models.dart';

class SignUpPage extends StatefulWidget { //statefull karna ada perubahan dalam form
  @override
  _SignUpPageState createState() => _SignUpPageState();
}
// State untuk SignUpPage, menyimpan input, loading, dan validasi form
class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>(); //keyform utk validasi email dan pw
  bool _loading = false;
// Controller untuk menangkap input user
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPw = TextEditingController();

  @override
  void dispose() {// Hapus controller saat widget dihapus agar tidak memory leak
    _controllerFullName.dispose();
    _controllerUserName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPw.dispose();
    super.dispose();
  }

  void handleSignUp() async {// Fungsi utama untuk menangani proses registrasi
    if (!_formKey.currentState!.validate()) {// Jika form tidak valid, tampilkan snackbar error

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mohon isi semua data dengan benar"),
        backgroundColor: Colors.red,
      ),
    );

    return;
  }

    final fullName = _controllerFullName.text.trim(); // trim utk mengambil input user dan menghapus spasi di awal/akhir, sedangkan
    final username = _controllerUserName.text.trim();
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();
    final confirmPassword = _controllerConfirmPw.text.trim();

    if (password != confirmPassword) {// Validasi password dan confirm password harus sama
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password dan Confirm Password tidak sama")),
      );
      return;
    }

    setState(() => _loading = true); // tampilkan loading spinner

try {// Panggil AuthServices untuk registrasi

    var newUser = await Provider.of<AuthServices>(context, listen: false)
        .signUp(fullName, username, email, password, confirmPassword);

    if (newUser != null) {

      _showSuccessDialog();// Jika berhasil registrasi, tampilkan dialog sukses

    }

  } catch (e) {
 // Jika email sudah terdaftar, tampilkan dialog khusus
    if (e.toString().contains("email-already-in-use")) {

      _showEmailExistDialog();

    } else {
// Error lain ditampilkan via snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );

    }

  }

  setState(() => _loading = false);// hilangkan loading spinner
}
// Dialog jika registrasi sukses
void _showSuccessDialog() {

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        title: Text("Registrasi Berhasil"),
        content: Text("Akun berhasil dibuat. Silakan login."),
        actions: [

          TextButton(
            onPressed: () {

              Navigator.pop(context);

              Navigator.pushReplacementNamed(context, "/SignInPage");

            },
            child: Text("OK"),
          )

        ],
      );

    },
  );
}
 // Dialog jika email sudah terdaftar
void _showEmailExistDialog() {

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        title: Text("Akun Sudah Terdaftar"),
        content: Text("Email ini sudah digunakan. Silakan login."),
        actions: [

          TextButton(
            onPressed: () {

              Navigator.pop(context);

              Navigator.pushReplacementNamed(context, "/SignInPage");

            },
            child: Text("Login"),
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
              margin: EdgeInsets.only(top: 50) , //atur jarak atas box radient
              height: MediaQuery.of(context).size.height, //tinggi box gradient
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
          key: _formKey, // key form
          child: ListView(
            children: [
              SizedBox(height: tinggi * 0.02), //atur jarak atas tulisan sign in
                    Text(
                      "Sign Up",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith( //menyalin style teks dari theme tapi mengubah ukuran font agar responsif.
                            fontSize: lebar * 0.07,
                            ),
                    ),
              SizedBox(height: tinggi * 0.05),
              TextFormField(
                controller: _controllerFullName,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return "Nama lengkap wajib diisi";
                  }

                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return "Nama hanya boleh huruf";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _controllerUserName,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username wajib diisi";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _controllerEmail,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                  ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return "Email wajib diisi";
                  }

                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Format email tidak valid";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
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

                  if (value.length < 6) {
                    return "Password minimal 6 karakter";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _controllerConfirmPw,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Konfirmasi password wajib diisi";
                  }

                  if (value != _controllerPassword.text) {
                    return "Password tidak sama";
                  }

                  return null;
                },
              ),
              SizedBox(height: 30),
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
              SizedBox(height: 25),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/SignInPage");
                },
                child: Text("Already have an Account? Sign In"),
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