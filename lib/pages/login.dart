import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/auth.dart';
import 'package:waste_management_flutter/services/widget_support.dart';
import 'package:waste_management_flutter/pages/role_selection.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "images/llogin.png",
                  height: 315,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20.0),
                Image.asset(
                  "images/Recycle_logo.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Reduce. Reuse. Recycle.",
                  style: AppWidget.healinetextstyle(20.0),
                ),
                Text(
                  "Repeat!!",
                  style: AppWidget.greentextstyle(30),
                ),
                const SizedBox(height: 40.0),
                Text(
                  "Each item you recycle creates\na positive impact!",
                  textAlign: TextAlign.center,
                  style: AppWidget.normaltextstyle(20.0),
                ),
                Text(
                  "Get Started!",
                  style: AppWidget.greentextstyle(25),
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    // Corrected to pass the "User" role as a second argument
                    AuthMethods().signInWithGoogle(context, "User");
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Image.asset(
                                "images/Google_logo.png",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Text(
                              "Sign in with Google",
                              style: AppWidget.Whitetextstyle(25.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          Positioned(
            top: 40,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleSelection(),
                  ),
                );
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(60),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}