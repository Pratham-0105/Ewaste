import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/auth.dart';
import 'package:waste_management_flutter/services/shared_pref.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email, image;

  @override
  void initState() {
    super.initState();
    getthesharedpref();
  }

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete your account?'),
                Text('This action is permanent and cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                AuthMethods().deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            Text("Profile Page", style: AppWidget.healinetextstyle(28.0)),
            const SizedBox(height: 30.0),
            image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(image!,
                  height: 120, width: 120, fit: BoxFit.cover),
            )
                : Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                  color: Color(0xFF41A7A5),
                  shape: BoxShape.circle),
              child: Center(
                  child: Text(name![0].toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 40.0),
            buildInfoCard(Icons.person_outline, "Name", name!),
            const SizedBox(height: 20.0),
            buildInfoCard(Icons.email_outlined, "Email", email!),
            const SizedBox(height: 40.0),
            buildActionButton(Icons.logout, "LogOut", () async {
              await AuthMethods().signOut(context);
            }),
            const SizedBox(height: 20.0),
            buildActionButton(Icons.delete_outline, "Delete Account", () {
              _showDeleteConfirmationDialog();
            }),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String label, String value) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 28.0),
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 16.0)),
                const SizedBox(height: 5.0),
                Text(value, style: AppWidget.normaltextstyle(18.0)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding:
          const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(icon, color: Colors.black87, size: 28.0),
              const SizedBox(width: 20.0),
              Text(text, style: AppWidget.normaltextstyle(20.0)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}