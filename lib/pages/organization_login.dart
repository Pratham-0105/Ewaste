import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/auth.dart';
import 'package:waste_management_flutter/services/widget_support.dart';
import 'package:waste_management_flutter/pages/role_selection.dart';

class OrganizationLogin extends StatefulWidget {
  const OrganizationLogin({super.key});

  @override
  State<OrganizationLogin> createState() => _OrganizationLoginState();
}

class _OrganizationLoginState extends State<OrganizationLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "images/llogin.png", // Reusing your existing login banner
                  height: 315,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20.0),
                // Icon representing Organization/Corporate waste management
                const Icon(
                  Icons.business_rounded,
                  size: 100,
                  color: Color(0xFF006064),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Corporate E-Waste Solutions",
                  style: AppWidget.healinetextstyle(20.0),
                ),
                Text(
                  "Bulk Recycling",
                  style: TextStyle(
                    color: const Color(0xFF006064),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40.0),
                Text(
                  "Manage your organization's electronic\nassets and environmental impact.",
                  textAlign: TextAlign.center,
                  style: AppWidget.normaltextstyle(18.0),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Get Started as Org!",
                  style: TextStyle(
                    color: const Color(0xFF006064),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    // This currently uses your existing Google Sign-In logic
                    AuthMethods().signInWithGoogle(context, "Organization");
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
                          color: const Color(0xFF006064), // Deep Teal for Org role
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
                                "images/Google_logo.png", // Reusing your Google logo
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

          // Back button to return to Role Selection
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