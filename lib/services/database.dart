import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- USER DATA ---
  // Saves core profile info (Name, Role, Email, etc.)
  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    return await _db
        .collection("users")
        .doc(id)
        .set(userInfoMap, SetOptions(merge: true));
  }

  // --- MARKETPLACE: RECYCLER DISCOVERY ---
  // Fetches all registered recyclers for the User to browse
  Future<Stream<QuerySnapshot>> getRegisteredRecyclers() async {
    return _db
        .collection("users")
        .where("Role", isEqualTo: "Recycler")
        .snapshots();
  }

  // --- UPLOAD & SELLING LOGIC ---
  // Fixes the 'Category' and 'id' parameter error by creating a dedicated item method
  Future addEwasteItem(Map<String, dynamic> itemInfo, String itemId) async {
    return await _db
        .collection("EwasteItems") // Global collection for easier Admin/Recycler access
        .doc(itemId)
        .set(itemInfo);
  }

  // Saves to User's private sub-collection for their "My Activity" section
  Future addUserUploadItem(Map<String, dynamic> userInfoMap, String id, String itemid) async {
    return await _db
        .collection("users")
        .doc(id)
        .collection("Items")
        .doc(itemid)
        .set(userInfoMap);
  }

  // Saves to Global Requests for Admin and Recycler visibility
  Future addAdminItem(Map<String, dynamic> userInfoMap, String id) async {
    return await _db
        .collection("Request")
        .doc(id)
        .set(userInfoMap);
  }

  // --- FETCHING REQUESTS (Real-time tracking) ---
  // Used by Admin to see what needs verification
  Future<Stream<QuerySnapshot>> getAdminApproval() async {
    return _db.collection("Request").where("Status", isEqualTo: "Pending").snapshots();
  }

  // Used by the User Lifecycle Tracker
  Future<Stream<QuerySnapshot>> getUserPendingRequests(String userId) async {
    return _db
        .collection("users")
        .doc(userId)
        .collection("Items")
        .snapshots();
  }

  // --- STATUS UPDATES (Lifecycle Management) ---
  // Updates the global request status (e.g., 'Pending' -> 'Approved')
  Future updateAdminRequest(String id, String status) async {
    return await _db
        .collection("Request")
        .doc(id)
        .update({"Status": status});
  }

  // Updates the specific user's item status to sync the progress bar
  Future updateUserRequest(String id, String itemid, String status) async {
    return await _db
        .collection("users")
        .doc(id)
        .collection("Items")
        .doc(itemid)
        .update({"Status": status});
  }

  // --- REDEMPTION & WALLET ---
  // Fetches pending point redemption requests for Admin
  Future<Stream<QuerySnapshot>> getAdminReedemApproval() async {
    return _db.collection("Reedem").where("Status", isEqualTo: "Pending").snapshots();
  }

  // Fetches a specific user's reward history
  Future<Stream<QuerySnapshot>> getUserTransactions(String id) async {
    return _db.collection("users").doc(id).collection("Reedem").snapshots();
  }

  // Updates user points using 'increment' to ensure accuracy during high traffic
  Future updateUserPoints(String id, int points) async {
    return await _db
        .collection("users")
        .doc(id)
        .update({"Points": FieldValue.increment(points)});
  }

  // Updates Admin-side redemption status
  Future updateAdminReedemRequest(String id) async {
    return await _db
        .collection("Reedem")
        .doc(id)
        .update({"Status": "Approved"});
  }

  // Updates User-side redemption status
  Future updateUserReedemRequest(String id, String itemid) async {
    return await _db
        .collection("users")
        .doc(id)
        .collection("Reedem")
        .doc(itemid)
        .update({"Status": "Approved"});
  }

  // Logs a new redemption request for a user
  Future addUserReedemPoints(Map<String, dynamic> userInfoMap, String id, String reedemid) async {
    return await _db
        .collection("users")
        .doc(id)
        .collection("Reedem")
        .doc(reedemid)
        .set(userInfoMap);
  }

  // Logs a new redemption request for the global Admin queue
  Future addAdminReedemRequest(Map<String, dynamic> userInfoMap, String reedemid) async {
    return await _db
        .collection("Reedem")
        .doc(reedemid)
        .set(userInfoMap);
  }

  // --- CLEANUP ---
  Future<void> deleteUserData(String id) async {
    return await _db.collection("users").doc(id).delete();
  }
}