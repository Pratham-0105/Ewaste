import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:waste_management_flutter/pages/home.dart';
import 'package:waste_management_flutter/pages/points.dart';
import 'profile.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {

  late List<Widget> pages;

  late Home homePage;
  late Points points;
  late Profile profilePage;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = Home();
    points = Points();
    profilePage = Profile();

   pages = [homePage, points, profilePage];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.green,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home,color: Colors.white, size: 34.0,),
          Icon(Icons.point_of_sale, color: Colors.white, size: 34.0,),
          Icon(Icons.person, color: Colors.white,size: 34.0,),
        ],

      ),
      body: pages[currentTabIndex],

    );
  }
}


