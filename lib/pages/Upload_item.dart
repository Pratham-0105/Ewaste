import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Gemini only
import 'package:random_string/random_string.dart';
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/shared_pref.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class UploadItem extends StatefulWidget {
  final String? Category;
  final String? id;
  const UploadItem({super.key, this.Category, this.id});

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  final List<String> items = ['Mobile', 'Laptop', 'Accessories', 'Other'];
  String? value, conditionValue, recommendation;
  bool isScanning = false;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController pointsController = TextEditingController();
  File? selectedImage;
  String? id, name, email;

  @override
  void initState() {
    super.initState();
    getthesharedpref();
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  // --- NEW GEMINI VISION METHOD (No ML Kit needed) ---
  Future<void> performGeminiVisionScan(File imageFile) async {
    setState(() => isScanning = true);

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyAgds1JrkJPpWaPbK_eSsRoxeT-Pdk0SCo',
      );

      final imageBytes = await imageFile.readAsBytes();
      final prompt = TextPart("""
        Analyze this electronic item. Provide exactly 5 lines:
        Name: [Model Name]
        Category: [Mobile or Laptop or Accessories]
        Condition: [Broken Screen or Working Perfectly or Not Turning On]
        Action: [REPAIR or RECYCLE]
        Points: [Value 50-200]
      """);

      final response = await model.generateContent([
        Content.multi([prompt, DataPart('image/jpeg', imageBytes)])
      ]);

      String text = response.text ?? "";

      setState(() {
        namecontroller.text = text.split("Name: ")[1].split("\n")[0];
        String cat = text.split("Category: ")[1].split("\n")[0];
        value = items.contains(cat) ? cat : "Other";
        conditionValue = text.split("Condition: ")[1].split("\n")[0];
        recommendation = text.contains("REPAIR") ? "REPAIR & REUSE" : "RECYCLE";
        pointsController.text = text.split("Points: ")[1].split("\n")[0].trim();
      });
    } catch (e) {
      debugPrint("AI Error: $e");
    } finally {
      setState(() => isScanning = false);
    }
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
      // 🔥 Call Gemini, not ML Kit
      await performGeminiVisionScan(selectedImage!);
    }
  }

  // ... (Rest of your uploadItem and build logic)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Vision Lab")),
      body: Center(child: Text("Ready for Gemini Scan")), // Simplified for brevity
    );
  }
}