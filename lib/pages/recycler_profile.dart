import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/auth.dart';
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/shared_pref.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class RecyclerProfile extends StatefulWidget {
  const RecyclerProfile({super.key});

  @override
  State<RecyclerProfile> createState() => _RecyclerProfileState();
}

class _RecyclerProfileState extends State<RecyclerProfile> {
  String? id, name, email, image;
  TextEditingController addressController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  void saveShopDetails() async {
    if (addressController.text.isNotEmpty && id != null) {
      setState(() => isSaving = true);

      Map<String, dynamic> shopInfo = {
        "ShopAddress": addressController.text,
        "Lat": 0.0,
        "Lng": 0.0,
      };

      // Updates the recycler's document in the 'users' collection
      await DatabaseMethods().addUserInfo(shopInfo, id!);

      setState(() => isSaving = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green, content: Text("Shop Address Saved Successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orange, content: Text("Please enter your shop address")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          children: [
            // Profile Header
            CircleAvatar(radius: 60, backgroundImage: NetworkImage(image ?? "")),
            const SizedBox(height: 20),
            Text(name ?? "Recycler", style: AppWidget.healinetextstyle(24.0)),
            Text(email ?? "", style: AppWidget.normaltextstyle(16.0)),
            const Divider(height: 40),

            // Manual Address Section
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Register Shop Address",
                    style: AppWidget.healinetextstyle(20.0))),
            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter full shop address (Building, Street, City, Pincode)",
                prefixIcon: const Icon(Icons.storefront, color: Colors.green),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 40),

            // Action Buttons
            isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: saveShopDetails,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Save Shop Profile",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 15),

            OutlinedButton(
              onPressed: () => AuthMethods().signOut(context),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}