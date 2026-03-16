// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'signInPage.dart';
import 'signUpPage.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;
    final tinggi = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Spacing atas
            SizedBox(height: tinggi * 0.05),

            // Logo
            Flexible(
              flex: 4,
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: lebar * 0.7,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: tinggi * 0.03),

            // Teks Intro
            Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: lebar * 0.05),
                child: Text(
                  "Stay organized\n Stay productive.",
                  style: TextStyle(
                    color: Color(0xFFC0CBAD),
                    fontSize: lebar * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),

            SizedBox(height: tinggi * 0.03),

            // Tombol GET STARTED
            Flexible(
              flex: 1,
              child: Center(
                child: SizedBox(
                  width: lebar * 0.6,
                  height: tinggi * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF8AB0AB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'GET STARTED',
                      style: TextStyle(
                        fontSize: lebar * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tombol Sign In
            Flexible(
              flex: 1,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text(
                    "Sign In to My Account",
                    style: TextStyle(
                      color: Color(0xFF8AB0AB),
                      fontSize: lebar * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: tinggi * 0.03),
          ],
        ),
      ),
    );
  }
}