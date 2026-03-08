import 'package:flutter/material.dart';
import 'package:waste_management_flutter/pages/role_selection.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Image.asset("images/onboard.png"),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Give your waste for Recycle!",
                style: AppWidget.healinetextstyle(30.0),
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                "Turn everyday household waste into something valuable",
                style: AppWidget.normaltextstyle(24.0),
              ),
            ),
            const SizedBox(height: 90.0),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RoleSelection()),
                );
              },
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      "Let's Go!!",
                      style: AppWidget.Whitetextstyle(24.0),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}