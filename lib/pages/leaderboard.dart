import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eco-Warriors"), centerTitle: true),
      body: Column(
        children: [
          // Global Impact Section
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.green, Colors.teal]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text("Total CO2 Diverted", style: TextStyle(color: Colors.white, fontSize: 16)),
                Text("1,240 kg", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                Text("Shared NMIMS Campus Goal", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").orderBy("Wallet", descending: true).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: index == 0 ? Colors.amber : Colors.grey.shade200,
                        child: Text("${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      title: Text(ds["Name"] ?? "User"),
                      subtitle: Text("Level: ${(int.parse(ds["Wallet"])/100).floor()} Eco-Hero"),
                      trailing: Text("${ds["Wallet"]} pts", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}