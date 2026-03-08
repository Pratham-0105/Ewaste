import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:waste_management_flutter/services/auth.dart';
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/shared_pref.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class RecyclerHome extends StatefulWidget {
  const RecyclerHome({super.key});

  @override
  State<RecyclerHome> createState() => _RecyclerHomeState();
}

class _RecyclerHomeState extends State<RecyclerHome> {
  String? id;
  TextEditingController addressController = TextEditingController();
  bool isLocating = false;
  double? lat, lng;

  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }

  getSharedPrefs() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  // --- GPS Location Logic ---
  Future<void> _detectLocation() async {
    setState(() => isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        lat = position.latitude;
        lng = position.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lng!);
        Placemark place = placemarks[0];

        setState(() {
          addressController.text = "${place.name}, ${place.subLocality}, ${place.locality} - ${place.postalCode}";
          isLocating = false;
        });
      }
    } catch (e) {
      setState(() => isLocating = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location detection failed.")));
    }
  }

  void saveShopDetails() async {
    if (addressController.text.isNotEmpty && id != null) {
      Map<String, dynamic> shopInfo = {
        "ShopAddress": addressController.text,
        "Lat": lat,
        "Lng": lng,
      };
      await DatabaseMethods().addUserInfo(shopInfo, id!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text("Shop Profile Updated!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        title: Text("Logistics Portal", style: AppWidget.Whitetextstyle(22.0)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => AuthMethods().signOut(context), icon: const Icon(Icons.logout, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- NEW: Shop Profile Section ---
            Text("Shop Location Setup", style: AppWidget.healinetextstyle(22.0)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  TextField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Enter Shop Address Manually",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _detectLocation,
                    child: Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.blue.shade700),
                        const SizedBox(width: 10),
                        isLocating
                            ? const SizedBox(height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text("Detect GPS Location", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: saveShopDetails,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 45)),
                    child: const Text("Save Shop Address", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30.0),
            Text("Operations Overview", style: AppWidget.healinetextstyle(24.0)),
            const SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStatCard("Pending Pickups", "08", Icons.local_shipping, Colors.green),
                buildStatCard("Today's Load", "140 kg", Icons.scale, Colors.blueGrey),
              ],
            ),

            const SizedBox(height: 30.0),
            Text("Logistics Management", style: AppWidget.healinetextstyle(22.0)),
            const SizedBox(height: 15.0),

            buildActionButton("Start Collection Scan", "Verify user QR & weight on-site", Icons.qr_code_scanner, const Color(0xFF388E3C)),
            const SizedBox(height: 15.0),
            buildActionButton("Dispatch to Facility", "Generate transit log for center", Icons.factory_outlined, Colors.black87),

            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  // ... (keep your existing buildStatCard and buildActionButton methods)
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opening $title...")));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
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