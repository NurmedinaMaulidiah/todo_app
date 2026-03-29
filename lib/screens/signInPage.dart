import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/theme/app_theme.dart';
import '../services/auth_services.dart';
import '../models/user_models.dart';

class SignInPage extends StatefulWidget { //statefull karena ada perubahan state kaya loading dan input form
  @override
  _SignInPageState createState() => _SignInPageState(); //// Membuat state untuk halaman SignIn agar bisa menyimpan data input & status loading
}
//inisialisai state clasa untuk halaman sign in page (semua data bisa berubah disini (email/pw) disimpaan dan dikelola)
class _SignInPageState extends State<SignInPage> { //pake state karena statefull
  final _formKey = GlobalKey<FormState>(); //formkey utk validasi email dan pw
  final TextEditingController _controllerEmail = TextEditingController(); //controller email dan pw utk nyimpan input user
  final TextEditingController _controllerPassword = TextEditingController();
  bool _loading = false; //menandai apakah proses login sedang berjalan, supaya tombol disable saat loading.

  @override
  void dispose() {
    _controllerEmail.dispose(); //berishkan controller email biaar ga leak
    _controllerPassword.dispose();
    super.dispose();
  }
//fungsi utama utk sign in
  void handleSignIn() async {
    if (!_formKey.currentState!.validate()) { // Cek validasi form, jika tidak valid tampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mohon isi email dan password"),
          backgroundColor: Colors.red,
        ),
      );

      return;// Hentikan proses jika form tidak valid
    }
    final email = _controllerEmail.text.trim();  // Ambil input dari user
    final password = _controllerPassword.text.trim();

    setState(() => _loading = true); // Tampilkan loading spinner

    try {// Panggil service login melalui Provider AuthServices
      var user = await Provider.of<AuthServices>(context, listen: false)
          .signIn(email, password);

      if (user != null) {
          _showLoginSuccessDialog();// Tampilkan dialog login berhasil
        }
      } catch (e) {  // Tangani error login
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
      setState(() => _loading = false); //matikan loading spinner stelah selesai
    }

    // Dialog login sukses
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

              Navigator.pop(context); //Navigator.pop digunakan untuk menutup halaman atau dialog saat ini dan kembali ke halaman sebelumnya.

              Navigator.pushReplacementNamed(context, "/HomePage"); //navigasi ke homepage jika berhasil login

            },
            child: Text("OK"),
          )

        ],
      );

    },
  );
}

// Dialog jika email tidak ditemukan
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

// Dialog jika pw salah
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
    final lebar = MediaQuery.of(context).size.width; //ambil lebar layar
    final tinggi = MediaQuery.of(context).size.height; //ambil tinggi layar

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Background default
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: lebar * 0.08), // Jarak atas bawah scroll
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
                key: _formKey, // Hubungkan form dengan key validasi
                child: Column(
                  children: [
                    SizedBox(height: tinggi * 0.05), //atur jarak atas tulisan sign in
                    Text(
                      "Sign In",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: lebar * 0.07), // Ukuran font responsif
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
                      validator: (value) { // Validasi email
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
                      controller: _controllerPassword, // Controller password
                      obscureText: true, // Sembunyikan karakter password
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
                        onPressed: _loading ? null : handleSignIn, // Tombol disable saat loading
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
                        Navigator.pushNamed(context, "/SignUpPage"); // Navigasi ke SignUpPage jika user belum punya aku
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