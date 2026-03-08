import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class AdminApproval extends StatefulWidget {
  const AdminApproval({super.key});

  @override
  State<AdminApproval> createState() => _AdminApprovalState();
}

class _AdminApprovalState extends State<AdminApproval> {
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

  // Logic to determine points based on E-Waste Category
  int calculatePoints(String category, String quantity) {
    double qty = double.tryParse(quantity) ?? 0.0;
    if (category == "Laptops") return (qty * 50).toInt();
    if (category == "Smartphones") return (qty * 30).toInt();
    if (category == "Batteries") return (qty * 20).toInt();
    if (category == "Power & Storage") return (qty * 40).toInt();
    return (qty * 15).toInt();
  }

  Widget allRequests() {
    return StreamBuilder(
      stream: requestStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            return Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("User: ${ds["Name"]}", style: AppWidget.healinetextstyle(18.0)),
                          Text(ds["Category"], style: AppWidget.greentextstyle(16.0)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("Address: ${ds["Address"]}", style: AppWidget.normaltextstyle(16.0)),
                      Text("Quantity: ${ds["Quantity"]} kg", style: AppWidget.normaltextstyle(16.0)),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          int pointsToAdd = calculatePoints(ds["Category"], ds["Quantity"]);

                          // FIXING THE ARGUMENT ERRORS HERE:
                          // 1. Update Global Request Status (Requires 2 args: ID and Status)
                          await DatabaseMethods().updateAdminRequest(ds.id, "Approved");

                          // 2. Update User's Item Status (Requires 3 args: UserID, ItemID, and Status)
                          // Note: Ensure your 'Request' collection stores the 'itemid' from the user's collection
                          await DatabaseMethods().updateUserRequest(ds["UserId"], ds.id, "Approved");

                          // 3. Update User Points
                          await DatabaseMethods().updateUserPoints(ds["UserId"], pointsToAdd);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("Approved! $pointsToAdd Points granted.")));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text("Approve & Recycled",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
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
      appBar: AppBar(
        title: Text("Request Approval", style: AppWidget.healinetextstyle(24.0)),
        centerTitle: true,
      ),
      body: allRequests(),
    );
  }
}