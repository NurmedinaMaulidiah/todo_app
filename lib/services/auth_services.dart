//untuk proses regis, login, dan hubungkan ke firebase aut dan firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_models.dart' as models;

class AuthServices extends ChangeNotifier {
  // proses inisialisasi FirebaseAuth & Firestore
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //proses regis
  Future<models.UserModel> signUp(String fullName, String username, String email, String password, String confirmPassword) async {
    // proses validasi password dan confirm password
    if (password != confirmPassword) {
      throw Exception("Password tidak sesuai!");
    }

    try {
      await _auth.createUserWithEmailAndPassword( // proses bikin akun di Firebase Auth
        email: email,
        password: password,
      );

      firebase_auth.User? user = _auth.currentUser;// ambil user yang baru dibuat

      await _firestore.collection('users').doc(user!.uid).set({ // proses simpan data tambahan user ke Firestore
        'fullName': fullName, //Firebase Auth cuma simpan email & password, tapi info lain (fullName, username) harus di Firestore
        'username': username,
        'email': email,
      });
      await _auth.signOut();   // proses sign out setelah registrasi agar user harus login manual


      return models.UserModel(// proses kembalikan model user yang baru dibuat
        fullName: fullName,
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
    } catch (e) {
      print('Gagal Registrasi: $e');// proses debugging
      throw e;
    }
  }

//proses fungsi sign in
  Future<models.UserModel> signIn(String email, String password) async {
    try {
       // proses login Firebase Auth
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      firebase_auth.User? user = _auth.currentUser;// ambil user yang sedang login

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();// proses ambil data user tambahan dari Firestore karena alasan: Firebase Auth hanya punya email, UID, tapi kita butuh fullName & username

      return models.UserModel.fromMap({// proses kembalikan model user
        'Fullname': userDoc.get('fullName'),
        'Username': userDoc.get('username'),
        'Email': userDoc.get('email'),
      });
    } catch (e) {
      print('Login failed: $e'); // proses debug
// proses bikin pesan error default
      String errorMessage = "Login Gagal! Akun tidak terdaftar";

      if (e is FirebaseAuthException) {// proses cek error spesifik dari Firebase Auth
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        }
      }

      throw errorMessage;// lempar error ke UI
    }
  }
}