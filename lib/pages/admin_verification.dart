import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class AdminVerification extends StatefulWidget {
  const AdminVerification({super.key});

  @override
  State<AdminVerification> createState() => _AdminVerificationState();
}

class _AdminVerificationState extends State<AdminVerification> {
  Stream? requestStream;

  ontheload() async {
    requestStream = await DatabaseMethods().getAdminApproval();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  // Logic to Approve Item and Award Points
  approveRequest(DocumentSnapshot ds) async {
    String userId = ds["UserId"];
    String itemId = ds.id;
    int rewardPoints = int.parse(ds["Points"]);

    // 1. Update Global Request Status
    await DatabaseMethods().updateAdminRequest(itemId, "Approved");

    // 2. Update User's specific item status
    await DatabaseMethods().updateUserRequest(userId, itemId, "Approved");

    // 3. Award Points to User Wallet
    await DatabaseMethods().updateUserPoints(userId, rewardPoints);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Item Approved! Points awarded to user.")));
  }

  Widget allRequests() {
    return StreamBuilder(
      stream: requestStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(ds["Image"], height: 80, width: 80, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ds["Name"], style: AppWidget.healinetextstyle(18.0)),
                                Text("User: ${ds["Username"]}", style: AppWidget.normaltextstyle(14.0)),
                                Text("Points: ${ds["Points"]}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => approveRequest(ds),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: const Text("Verify & Award Points", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verification Center", style: AppWidget.healinetextstyle(20.0)), centerTitle: true),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Expanded(child: allRequests()),
          ],
        ),
      ),
    );
  }
}