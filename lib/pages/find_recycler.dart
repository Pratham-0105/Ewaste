import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class FindRecycler extends StatefulWidget {
  const FindRecycler({super.key});

  @override
  State<FindRecycler> createState() => _FindRecyclerState();
}

class _FindRecyclerState extends State<FindRecycler> {
  Stream? recyclerStream;

  ontheload() async {
    // Fetches users where Role == 'Recycler'
    recyclerStream = await DatabaseMethods().getRegisteredRecyclers();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  // --- Logic to launch Phone Dialer ---
  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No contact number provided."))
      );
      return;
    }
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open phone dialer."))
      );
    }
  }

  Widget allRecyclers() {
    return StreamBuilder(
      stream: recyclerStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.docs.isEmpty) {
          return Center(
            child: Text("No recyclers found in your area.",
                style: AppWidget.normaltextstyle(16.0)),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recycler Shop Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ds["Image"] != null
                            ? Image.network(ds["Image"], height: 85, width: 85, fit: BoxFit.cover)
                            : Container(
                            height: 85, width: 85,
                            color: Colors.green.shade100,
                            child: const Icon(Icons.store, color: Colors.green)
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      // Recycler Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(ds["Name"], style: AppWidget.healinetextstyle(18.0)),
                                const Icon(Icons.verified, color: Colors.blue, size: 18),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    ds["ShopAddress"] ?? "Address details pending...",
                                    style: AppWidget.normaltextstyle(13.0),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Action Button
                            GestureDetector(
                              onTap: () => _makePhoneCall(ds["Email"]), // Assuming email/phone is stored
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone, color: Colors.white, size: 14),
                                    SizedBox(width: 5),
                                    Text("Contact Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Nearby Recyclers", style: AppWidget.healinetextstyle(20.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            // Search Bar for UI polish
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search by shop name or city...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(child: allRecyclers()),
          ],
        ),
      ),
    );
  }
}