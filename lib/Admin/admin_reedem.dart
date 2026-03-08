import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import '../services/widget_support.dart';

class AdminReedem extends StatefulWidget {
  const AdminReedem({super.key});

  @override
  State<AdminReedem> createState() => _AdminReedemState();
}

class _AdminReedemState extends State<AdminReedem> {
  Stream? reedemStream;

  getontheload() async {
    reedemStream = await DatabaseMethods().getAdminReedemApproval();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }


  Widget allApprovals() {
    return StreamBuilder(
      stream: reedemStream,
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
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      ds["Date"],
                      textAlign: TextAlign.center,
                      style: AppWidget.Whitetextstyle(18.0),
                    ),
                  ),
                  const SizedBox(width: 15.0),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person,
                                color: Colors.green, size: 25.0),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Text(
                                ds["Name"],
                                style: AppWidget.normaltextstyle(18.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.point_of_sale,
                                color: Colors.green, size: 25.0),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Text(
                                "Points Redeemed: ${ds["Points"].toString()}",
                                style: AppWidget.normaltextstyle(18.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                color: Colors.green, size: 25.0),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Text(
                                "UPI ID: ${ds["UPI"]}",
                                style: AppWidget.normaltextstyle(18.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),

                        GestureDetector(
                          onTap: () async {
                            await DatabaseMethods().updateAdminReedemRequest(ds.id);
                            await DatabaseMethods()
                                .updateUserReedemRequest(ds["UserId"], ds.id);
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Approved",
                                style: AppWidget.Whitetextstyle(18.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
      body: Stack(
        children: [

          Container(
            margin: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Redeem Requests",
                        style: AppWidget.healinetextstyle(25.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Color.fromARGB(255, 233, 233, 249),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: allApprovals(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 30,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(60),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 28.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
