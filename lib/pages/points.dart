import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/shared_pref.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class Points extends StatefulWidget {
  const Points({super.key});

  @override
  State<Points> createState() => _PointsState();
}

class _PointsState extends State<Points> {
  String? id, wallet;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  // --- Winning Feature: Impact Stats Logic ---
  Widget buildImpactStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(value, style: AppWidget.healinetextstyle(20.0)),
        Text(label, style: AppWidget.normaltextstyle(12.0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hackathon Math: Assume 10 points = 1kg CO2 offset and 2 Liters of water saved
    double points = double.tryParse(wallet ?? "0") ?? 0;
    double co2Saved = points / 10;
    double waterSaved = co2Saved * 2.5;

    return Scaffold(
      body: id == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Eco Rewards", style: AppWidget.healinetextstyle(24.0)),
            const SizedBox(height: 20.0),

            // Wallet Card
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade400]),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Available Eco-Points", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars, color: Colors.amber, size: 30),
                      const SizedBox(width: 10),
                      Text(wallet ?? "0", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30.0),

            // --- Hackathon Winning Feature: Impact Dashboard ---
            Text("Your Green Impact", style: AppWidget.healinetextstyle(20.0)),
            const SizedBox(height: 15.0),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildImpactStat(Icons.cloud_done, "${co2Saved.toStringAsFixed(1)} kg", "CO2 Offset", Colors.blue),
                  const VerticalDivider(thickness: 1),
                  buildImpactStat(Icons.opacity, "${waterSaved.toStringAsFixed(1)} L", "Water Saved", Colors.teal),
                  const VerticalDivider(thickness: 1),
                  buildImpactStat(Icons.eco, "${(points/50).floor()}", "Trees Planted", Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 30.0),

            Text("How to earn more?", style: AppWidget.healinetextstyle(18.0)),
            const SizedBox(height: 10.0),

            // Tips List
            Expanded(
              child: ListView(
                children: [
                  rewardTile(Icons.laptop, "Recycle a Laptop", "+150 Points"),
                  rewardTile(Icons.phone_android, "Recycle a Mobile", "+50 Points"),
                  rewardTile(Icons.camera_alt, "Recycle Accessories", "+20 Points"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rewardTile(IconData icon, String title, String points) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: AppWidget.normaltextstyle(16.0)),
      trailing: Text(points, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    );
  }
}