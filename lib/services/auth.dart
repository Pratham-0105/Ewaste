import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waste_management_flutter/Admin/home_admin.dart';
import 'package:waste_management_flutter/pages/bottomnav.dart';
import 'package:waste_management_flutter/pages/organization_home.dart';
import 'package:waste_management_flutter/pages/recycler_home.dart';
import 'package:waste_management_flutter/pages/login.dart';
import 'package:waste_management_flutter/services/database.dart';
import 'package:waste_management_flutter/services/shared_pref.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Updated to support the distinct flow for all 4 roles
  Future<void> signInWithGoogle(BuildContext context, String role) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential result = await _auth.signInWithCredential(credential);
        User? userDetails = result.user;

        if (userDetails != null) {
          // Saving details to shared preferences for persistence
          await SharedPreferenceHelper().saveUserEmail(userDetails.email!);
          await SharedPreferenceHelper().saveUserId(userDetails.uid);
          await SharedPreferenceHelper().saveUserImage(userDetails.photoURL!);
          await SharedPreferenceHelper().saveUserName(userDetails.displayName!);

          final DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(userDetails.uid)
              .get();

          // Creating a map to sync role and initial impact data to Firestore
          Map<String, dynamic> userInfoMap = {
            "email": userDetails.email,
            "name": userDetails.displayName,
            "image": userDetails.photoURL,
            "Id": userDetails.uid,
            "Role": role,
            if (!userDoc.exists) "Points": 0,
            if (!userDoc.exists) "CarbonSaved": 0.0, // New field for the Impact Diagram
          };

          await DatabaseMethods().addUserInfo(userInfoMap, userDetails.uid);

          // Parallel navigation flow as per your new diagram
          if (role == "Organization") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OrganizationHome()),
            );
          } else if (role == "Recycler") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RecyclerHome()),
            );
          } else if (role == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeAdmin()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Bottomnav()),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Firebase Error: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text("Login Failed. Check SHA-1 or Internet.")),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    // Clearing local cache to prevent role-mismatch errors on re-login
    await SharedPreferenceHelper().saveUserId('');
    await SharedPreferenceHelper().saveUserName('');
    await SharedPreferenceHelper().saveUserEmail('');
    await SharedPreferenceHelper().saveUserImage('');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false,
    );
  }

  // Method to re-authenticate and delete user as per your diagram's data privacy flow
  Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      String userId = user.uid;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
        await user.delete();
        await DatabaseMethods().deleteUserData(userId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
              (route) => false,
        );
      }
    } catch (e) {
      print("Delete Account Error: $e");
    }
  }
}