import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_management_flutter/pages/Upload_item.dart';
import 'package:waste_management_flutter/pages/find_recycler.dart';
import 'package:waste_management_flutter/pages/leaderboard.dart'; // Import Leaderboard
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/pdf_service.dart';
import 'package:waste_management_flutter/services/shared_pref.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? id, name, image, wallet;
  Stream? pendingStream;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    if (id != null) {
      pendingStream = await DatabaseMethods().getUserPendingRequests(id!);
      setState(() {});
    }
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget statusCircle(bool active, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: active ? Colors.green : Colors.grey.shade300,
          child: active ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
        ),
        const SizedBox(height: 5),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: active ? Colors.green.shade800 : Colors.grey,
                fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget statusLine(bool active) => Expanded(
    child: Container(
      height: 3,
      color: active ? Colors.green : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 18),
    ),
  );

  Widget allPendingRequests() {
    return StreamBuilder(
      stream: pendingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        var docs = snapshot.data.docs;
        if (docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("No active pickups yet. Start recycling!",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = docs[index];
            String status = ds["Status"] ?? "Pending";
            bool isApproved = status == "Approved" || status == "Recycled";

            return Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(ds["Name"] ?? "Item", style: AppWidget.healinetextstyle(18.0)),
                        ],
                      ),
                      isApproved
                          ? IconButton(
                        onPressed: () {
                          PdfService.generateCertificate(
                              ds["Name"], ds["Points"].toString(), name ?? "User");
                        },
                        icon: const Icon(Icons.card_membership, color: Colors.green, size: 28),
                        tooltip: "Download Certificate",
                      )
                          : Text("+${ds["Points"] ?? "0"} pts",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      statusCircle(true, "Sent"),
                      statusLine(status != "Pending"),
                      statusCircle(status != "Pending", "Verified"),
                      statusLine(isApproved),
                      statusCircle(isApproved, "Done"),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double points = double.tryParse(wallet ?? "0") ?? 0;
    double co2Saved = points / 10;
    int treesSaved = (points / 50).floor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text("Hello, ", style: AppWidget.healinetextstyle(24.0)),
                    Text(name!, style: AppWidget.greentextstyle(22.0)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, border: Border.all(color: Colors.green, width: 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: image != null
                              ? Image.network(image!, height: 45, width: 45, fit: BoxFit.cover)
                              : const Icon(Icons.person, size: 45),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25.0),

              // Marketplace Banner
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FindRecycler())),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.black, Color(0xFF333333)]),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.storefront, color: Colors.white)),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Marketplace", style: AppWidget.Whitetextstyle(20.0)),
                          const Text("Sell items to local shops",
                              style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0),

              // --- 2. Dynamic Eco Impact Dashboard with Leaderboard Link ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.green.shade900, Colors.green.shade700]),
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        impactMetric(Icons.cloud_done, "${co2Saved.toStringAsFixed(1)}kg", "CO2 Offset"),
                        impactMetric(Icons.eco, treesSaved.toString().padLeft(2, '0'), "Eco Points"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Colors.white24, thickness: 1),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard())),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.leaderboard, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text("View Global Leaderboard >",
                                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, decoration: TextDecoration.underline, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Quick Recycle", style: AppWidget.healinetextstyle(22.0)),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20.0),
                  children: [
                    categoryCard("Laptops", Icons.laptop_mac, "Laptop"),
                    categoryCard("Phones", Icons.phone_android, "Mobile"),
                    categoryCard("Battery", Icons.battery_alert, "Accessories"),
                    categoryCard("Cables", Icons.cable, "Accessories"),
                    categoryCard("Others", Icons.devices_other, "Other"),
                  ],
                ),
              ),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Waste Tracker", style: AppWidget.healinetextstyle(22.0)),
                    Icon(Icons.history, color: Colors.green.shade800),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              allPendingRequests(),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget impactMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget categoryCard(String title, IconData icon, String catName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadItem(Category: catName, id: id!)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.black12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
              ),
              child: Icon(icon, size: 40, color: Colors.green.shade700),
            ),
            const SizedBox(height: 8.0),
            Text(title, style: AppWidget.normaltextstyle(14.0)),
          ],
        ),
      ),
    );
  }
}