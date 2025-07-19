import 'package:classbridge/views/home_screen.dart';
import 'package:classbridge/views/main_screen.dart';
import 'package:classbridge/views/parents_screen/parents_main_screen.dart';
import 'package:classbridge/views/parents_screen/parents_signup.dart';
import 'package:classbridge/views/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  bool bifurcation;
  SplashScreen({super.key, required this.bifurcation});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    timer();
  }

  Future timer() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final time = Future.delayed(Duration(seconds: 2), () async {
        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? type = prefs.getString("type") ?? "";
          if (type == "parents") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ParentsMainScreen()),
            );
          } else if (type == "teachers") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        } else {
          setState(() {
            widget.bifurcation = true;
          });
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const LoginScreen()),
          // );
        }
      });
      return time;
    } catch (e) {
      print("Error in splash screen: $e");
      // return Future.delayed(Duration(seconds: 2), () {
      //   setState(() {
      //     widget.bifurcation = true;
      //   });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_rounded, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'EASY ASSESSMENT',
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ],
              )),
            ),
            widget.bifurcation
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ParentsSignup()),
                            );
                          },
                          child: Text(
                            "Parents",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 12,
            ),
            widget.bifurcation
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "Teachers",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
