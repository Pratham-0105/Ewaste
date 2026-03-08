import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/auth.dart';
import 'package:waste_management_flutter/services/widget_support.dart';
import 'package:waste_management_flutter/pages/role_selection.dart';

class RecyclerLogin extends StatefulWidget {
  const RecyclerLogin({super.key});

  @override
  State<RecyclerLogin> createState() => _RecyclerLoginState();
}

class _RecyclerLoginState extends State<RecyclerLogin> {
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
                const Icon(
                  Icons.precision_manufacturing_rounded,
                  size: 100,
                  color: Color(0xFF388E3C),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Authorized Recycling Partner",
                  style: AppWidget.healinetextstyle(20.0),
                ),
                Text(
                  "Recycler Portal",
                  style: TextStyle(
                    color: const Color(0xFF388E3C),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40.0),
                Text(
                  "Access pending e-waste collections and\nmanage recovery operations.",
                  textAlign: TextAlign.center,
                  style: AppWidget.normaltextstyle(18.0),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Join the Circular Economy",
                  style: TextStyle(
                    color: const Color(0xFF388E3C),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    AuthMethods().signInWithGoogle(context, "Recycler");
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
                          color: const Color(0xFF388E3C),
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
                ),
                const SizedBox(height: 40.0),
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