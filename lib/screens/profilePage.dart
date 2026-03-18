import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/screens/Introduction_screen.dart';
import '../theme/app_theme.dart';


class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  // Function untuk mengambil data user dari Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gradientGreen,
      appBar: AppBar(
        title: Text("Profile"),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.gradientGreen,
              AppTheme.darkBg,
            ],
          ),
        ),

        child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var userData = snapshot.data as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // Avatar
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppTheme.pressedColor,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 30),

                  // Card Profile Info
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [

                        // USERNAME
                        ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text("Username"),
                          subtitle: Text(userData['username'] ?? "-"),
                        ),

                        Divider(),

                        // FULL NAME
                        ListTile(
                          leading: Icon(Icons.badge),
                          title: Text("Full Name"),
                          subtitle: Text(userData['fullName'] ?? "-"),
                        ),

                        Divider(),

                        // EMAIL
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text("Email"),
                          subtitle: Text(userData['email'] ?? "-"),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // BUTTON LOGOUT
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.logout),
                      label: Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.pressedColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                     onPressed: () async {
                        await FirebaseAuth.instance.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => IntroductionPage()),
                          (route) => false,
                        );
                      },
                    ),
                  )

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}