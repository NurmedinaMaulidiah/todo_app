import 'package:flutter/material.dart';
import 'signInPage.dart';
import 'signUpPage.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;
    final tinggi = MediaQuery.of(context).size.height;

    return Scaffold(
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  body: SafeArea(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // LOGO
          Image.asset(
            'assets/logo.png',
            width: lebar * 0.8,
          ),

          SizedBox(height: tinggi * 0.04),

          // SAGENA APPS
          Text(
            "SAGENA APPS",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: lebar * 0.09,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          SizedBox(height: tinggi * 0.01),

          // SAVE YOUR AGENDA
          Text(
            "Save Your Agenda",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white70,
            ),
          ),

          SizedBox(height: tinggi * 0.06),

          // BUTTON GET STARTED
          SizedBox(
            width: lebar * 0.6,
            height: tinggi * 0.07,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color(0xFF3E505B);
                  }
                  return const Color(0xFF8AB0AB);
                }),
              ),
              child: Text(
                "GET STARTED",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: tinggi * 0.015),

          // SIGN IN
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            child: Text(
              "Sign In to My Account",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}