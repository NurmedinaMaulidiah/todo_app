import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_models.dart' as models;

class AuthServices extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<models.UserModel> signUp(String fullName, String username, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      throw Exception("Password tidak sesuai!");
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      firebase_auth.User? user = _auth.currentUser;

      await _firestore.collection('users').doc(user!.uid).set({
        'fullName': fullName,
        'username': username,
        'email': email,
      });
      await _auth.signOut();

      return models.UserModel(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
    } catch (e) {
      print('Gagal Registrasi: $e');
      throw e;
    }
  }

  Future<models.UserModel> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      firebase_auth.User? user = _auth.currentUser;

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();

      return models.UserModel.fromMap({
        'Fullname': userDoc.get('fullName'),
        'Username': userDoc.get('username'),
        'Email': userDoc.get('email'),
      });
    } catch (e) {
      print('Login failed: $e');

      String errorMessage = "Login Gagal! Akun tidak terdaftar";

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        }
      }

      throw errorMessage;
    }
  }
}