import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends ChangeNotifier {
  String fullName = "";
  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  UserModel({
    this.fullName = "",
    this.username = "",
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
  });

  void setUser({
    required String fullName,
    required String username,
    required String email,
  }) {
    this.fullName = fullName;
    this.username = username;
    this.email = email;
    notifyListeners();
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['Fullname'] ?? '',
      username: map['Username'] ?? '',
      email: map['Email'] ?? '',
    );
  }
}