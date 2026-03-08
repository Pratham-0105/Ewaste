import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:waste_management_flutter/pages/recycler_home.dart';
import 'package:waste_management_flutter/pages/recycler_profile.dart';

class RecyclerNav extends StatefulWidget {
  const RecyclerNav({super.key});

  @override
  State<RecyclerNav> createState() => _RecyclerNavState();
}

class _RecyclerNavState extends State<RecyclerNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late RecyclerHome home;
  late RecyclerProfile profile;

  @override
  void initState() {
    home = const RecyclerHome();
    profile = const RecyclerProfile();
    pages = [home, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: const Color(0xFFF2F2F2),
        color: const Color(0xFF388E3C), // Industrial Green theme
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) => setState(() => currentTabIndex = index),
        items: const [
          Icon(Icons.local_shipping, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}