import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_management_flutter/Admin/home_admin.dart';
import 'package:waste_management_flutter/services/widget_support.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}


final TextEditingController usernamecontroller = TextEditingController();
final TextEditingController userpasswordcontroller = TextEditingController();

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          Center(
            child: Image.asset(
              "images/llogin.png",
              height: 315,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 20.0,),
          Text("Admin Login", style: AppWidget.healinetextstyle(28.0),),
          SizedBox(height: 20.0,),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(96, 76, 178,79),borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40.0))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Usermame", style: AppWidget.normaltextstyle(20.0),),
                ),
                  SizedBox(height:10.0,),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Material(
                    elevation: 2.0,borderRadius: BorderRadius.circular(10),
                    child: Container(

                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child:
                      TextField(
                        controller: usernamecontroller,
                        decoration: InputDecoration(border: InputBorder.none, hintText: "Enter the Username", hintStyle: AppWidget.normaltextstyle(18.0),
                            prefixIcon: Icon(Icons.person,  color: Colors.green,)),

                      ),),
                  ),
                ),

                  SizedBox(height: 30.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Password 🤫", style: AppWidget.normaltextstyle(20.0),),
                  ),
                  SizedBox(height:10.0,),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 2.0,borderRadius: BorderRadius.circular(10),
                      child: Container(

                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child:
                        TextField(
                          controller: userpasswordcontroller,
                          obscureText: true,
                          decoration: InputDecoration(border: InputBorder.none, hintText: "Enter the Password", hintStyle: AppWidget.normaltextstyle(18.0),
                              prefixIcon: Icon(Icons.password_sharp,  color: Colors.green,)),

                        ),),
                    ),
                  ),

                  SizedBox(height: 50.0,),
                  GestureDetector(
                    onTap: (){
                      LoginAdmin();
                    },
                    child: Center(
                      child: Container(
                        height: 55,
                        width: 200,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(50.0)),
                        child: Center(child: Text("Login", style: AppWidget.Whitetextstyle(25.0),)),
                      ),
                    ),
                  )
              ],),
            ),
          )

        ],),
      ),
    );
  }

  LoginAdmin() {
    FirebaseFirestore.instance
        .collection("Admin")
        .where('id', isEqualTo: usernamecontroller.text.trim())
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Username not found", style: TextStyle(fontSize: 18.0))));
        return;
      }

      var adminData = snapshot.docs.first.data();
      if (adminData['password'] != userpasswordcontroller.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Your Password is not Correct", style: TextStyle(fontSize: 18.0))));
      } else {
        Route route = MaterialPageRoute(builder: (context) => HomeAdmin());
        Navigator.pushReplacement(context, route);
      }
    }).catchError((error) {
      // This will trigger if there is a real connection/Firebase error
      print("Firebase Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Connection Error: Check internet or Firebase config")));
    });
  }}