//utk myimpan data user di apk, update data user di apk, dan convert data firestore ke model  
import 'package:flutter/foundation.dart'; // proses pakai ChangeNotifier untuk state management (supaya setiap perubahan data di UserModel otomatis memberi tahu UI untuk update)
import 'package:cloud_firestore/cloud_firestore.dart';

//proses nyimpan data lengkap user
class UserModel extends ChangeNotifier {
  String fullName = "";
  String username = "";
  String email = "";
  String password = ""; //pw sementara di app
  String confirmPassword = ""; //pw sementara di app

//konstruksi user model
  UserModel({
    this.fullName = "",
    this.username = "",
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
  });
 // PROSES SET USER
  void setUser({
    required String fullName,
    required String username,
    required String email,
  }) {
    this.fullName = fullName;// proses update data user di app
    this.username = username;
    this.email = email;
    notifyListeners(); // proses beri tahu UI bahwa data user berubah
  }
// PROSES DARI FIRESTORE KE MODEL USER
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(     // proses convert data mentah dari Firestore ke object UserModel
      fullName: map['Fullname'] ?? '',
      username: map['Username'] ?? '',
      email: map['Email'] ?? '',
    );
  }
}