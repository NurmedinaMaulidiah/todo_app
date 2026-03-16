import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              child: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 25),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/SignInPage");
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          width: MediaQuery.of(context).size.width,
                          height: 24,
                          child: Image.asset("assets/buttonBack.png"),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      SizedBox(height: 100),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 30),
                        child: Text(
                          "Registration\nsuccessful.",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 270,
                        child: Image.asset("assets/Success.png"),
                      ),
                      SizedBox(height: 100),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/SignInPage");
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.9, 50),
                          ),
                          child: Text("Sign In"),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
