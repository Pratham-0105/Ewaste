import 'package:flutter/material.dart';
import 'package:waste_management_flutter/Admin/admin_approval.dart';
import 'package:waste_management_flutter/Admin/admin_reedem.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Admin Command Center",
                  style: AppWidget.healinetextstyle(28.0),
                ),
              ),
              const SizedBox(height: 30.0),

              // Feature from Diagram: System Health & Sync Status
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sync_alt, color: Colors.green),
                    const SizedBox(width: 15),
                    Text(
                      "System Status: Online & Syncing",
                      style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25.0),

              // Feature from Diagram: Global Waste Analytics
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Network Impact", style: AppWidget.Whitetextstyle(20)),
                        const Icon(Icons.insights, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        analyticsStat("840kg", "Total E-Waste"),
                        analyticsStat("2.1t", "CO2 Saved"),
                        analyticsStat("15", "Active Recyclers"),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40.0),

              Text("Processing Portal", style: AppWidget.healinetextstyle(22.0)),
              const SizedBox(height: 20.0),

              // Admin Task: Approval (Linked to User Lifecycle)
              adminTaskCard(
                context,
                "Request Verification",
                "Approve pickups & grant points",
                Icons.fact_check_outlined,
                const AdminApproval(),
              ),

              const SizedBox(height: 20.0),

              // Admin Task: Redemption (Financial Settlement)
              adminTaskCard(
                context,
                "Payment Requests",
                "Verify UPI & Process Payouts",
                Icons.payments_outlined,
                const AdminReedem(),
              ),

              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget analyticsStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget adminTaskCard(BuildContext context, String title, String subtitle, IconData icon, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
      },
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 35, color: Colors.black),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppWidget.healinetextstyle(18.0)),
                    Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}