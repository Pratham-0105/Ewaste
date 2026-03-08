import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/auth.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class OrganizationHome extends StatefulWidget {
  const OrganizationHome({super.key});

  @override
  State<OrganizationHome> createState() => _OrganizationHomeState();
}

class _OrganizationHomeState extends State<OrganizationHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006064), // Corporate Teal Theme
        title: Text("Organization Portal", style: AppWidget.Whitetextstyle(22.0)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => AuthMethods().signOut(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ESG Compliance Overview", style: AppWidget.healinetextstyle(24.0)),
            const SizedBox(height: 20.0),

            // Feature from Diagram: System Measurement & Impact
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStatCard("Total Retired", "1.4 Tons", Icons.business_center, Colors.teal),
                buildStatCard("Certificates", "06 Issued", Icons.verified, Colors.blueGrey),
              ],
            ),

            const SizedBox(height: 30.0),
            Text("Bulk Asset Inventory", style: AppWidget.healinetextstyle(22.0)),
            const SizedBox(height: 15.0),

            // Feature from Diagram: Asset Management
            buildActionButton(
              "Schedule Bulk Pickup",
              "Industrial collection for assets > 100kg",
              Icons.local_shipping_outlined,
              const Color(0xFF006064),
            ),

            const SizedBox(height: 15.0),

            // Feature from Diagram: ESG Reporting System
            buildActionButton(
              "Generate Audit Report",
              "Official ESG documentation for FY 2025-26",
              Icons.analytics_outlined,
              Colors.black87,
            ),

            const SizedBox(height: 30.0),
            Text("Corporate Disposal Logs", style: AppWidget.healinetextstyle(20.0)),
            const SizedBox(height: 10.0),

            // Mock Data representing the 'Feature Stock Inventory' from diagram
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.teal.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  logRow("Batch #882", "Server Racks", "Approved"),
                  const Divider(),
                  logRow("Batch #879", "Office Laptops", "In-Transit"),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget logRow(String id, String item, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(item),
          Text(status, style: TextStyle(color: status == "Approved" ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildStatCard(String label, String value, IconData icon, Color color) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.4,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(String title, String subtitle, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Initializing $title...")),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 35),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppWidget.Whitetextstyle(18.0)),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}