import 'package:flutter/material.dart';
import 'package:waste_management_flutter/Admin/admin_login.dart';
import 'package:waste_management_flutter/pages/login.dart';
import 'package:waste_management_flutter/services/widget_support.dart';
import 'package:waste_management_flutter/pages/organization_login.dart';
import 'package:waste_management_flutter/pages/recycler_login.dart';

class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Added SingleChildScrollView to prevent overflow with new buttons
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "images/llogin.png",
                  height: 315,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10.0),
              Image.asset("images/Recycle_logo.png",
                  height: 80, width: 80, fit: BoxFit.cover),
              const SizedBox(height: 10.0),
              Text(
                "Reduce. Reuse. Recycle.",
                style: AppWidget.healinetextstyle(20.0),
              ),
              Text(
                "Repeat!!",
                style: AppWidget.greentextstyle(30),
              ),
              const SizedBox(height: 30.0),

              // 1. Admin Login Button
              buildRoleButton(
                  context,
                  "Admin Login",
                  Colors.black,
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLogin()))
              ),
              const SizedBox(height: 20.0),

              // 2. User Login Button
              buildRoleButton(
                  context,
                  "User Login",
                  Colors.green,
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()))
              ),
              const SizedBox(height: 20.0),

              // 3. Organization Login Button
              // 3. Organization Login Button
              buildRoleButton(
                context,
                "Organizations",
                const Color(0xFF006064),
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrganizationLogin()),
                ),
              ),
              const SizedBox(height: 20.0),

              // 4. Recycler Login Button
              buildRoleButton(
                  context,
                  "Recyclers",
                  const Color(0xFF388E3C), // Dark Green color
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RecyclerLogin())
                    );
                  }
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to keep the code clean and consistent
  Widget buildRoleButton(BuildContext context, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: AppWidget.Whitetextstyle(22.0),
            ),
          ),
        ),
      ),
    );
  }
}