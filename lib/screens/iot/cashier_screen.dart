import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/theme.dart';
import 'package:flutter/material.dart';

class IotScreen extends StatefulWidget {
  const IotScreen({Key? key}) : super(key: key);

  @override
  State<IotScreen> createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen> {
  String _leadeingHour = "";
  String _minute = "";
  Timer? _timer;
  void _updateLeadingHour() {
    _leadeingHour = DateTime.now().hour.toString().padLeft(2, '0');
    _minute = DateTime.now().minute.toString().padLeft(2, '0');
    setState(() {
      _leadeingHour;
      _minute;
    });
    _timer = Timer(const Duration(minutes: 1), _updateLeadingHour);
  }

  @override
  void initState() {
    _updateLeadingHour();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("pengunjung").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var items = snapshot.data;
              items!.docs[items.docs.length - 1]
                  .data()
                  .toString()
                  .contains("pengunjung_jam_$_leadeingHour");
              final pengunjungDataNowHour = items!.docs[items.docs.length - 1]
                      .data()
                      .toString()
                      .contains("pengunjung_jam_$_leadeingHour")
                  ? items.docs[items.docs.length - 1]
                          ["pengunjung_jam_$_leadeingHour"]
                      .toString()
                  : "0";
              Future<String?> pengunjungDataNow({int kapan = 0}) async {
                String currentDate =
                    "${(now.day - kapan).toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString()}";

                String? dataDocs;
                await FirebaseFirestore.instance
                    .collection("pengunjung")
                    .doc(currentDate)
                    .get()
                    .then((docSnapshot) {
                  if (docSnapshot.exists &&
                      docSnapshot.data()!.containsKey("value")) {
                    dataDocs = docSnapshot.data()!["value"].toString();
                  } else {
                    dataDocs = "0";
                  }
                });
                return dataDocs;
              }

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.green),
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.15, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                          future: pengunjungDataNow(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.hasData) {
                              return boxRectangle("Hari ini", snapshot.data!);
                            } else {
                              return boxRectangle("Hari ini", "...");
                            }
                          },
                        ),
                        FutureBuilder(
                          future: pengunjungDataNow(kapan: 1),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.hasData) {
                              return boxRectangle("Kemarin", snapshot.data!);
                            } else {
                              return boxRectangle("Kemarin", "...");
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: boxRectangle(
                                "Pengunjung ${DateTime.now().hour > 20 || DateTime.now().hour < 7 ? "" : "Jam $_leadeingHour : $_minute"}",
                                pengunjungDataNowHour,
                                height: 130)),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Data",
                        style: whiteTextStyle.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.37,
                            child: SingleChildScrollView(
                              physics: const ScrollPhysics(),
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView(
                                  reverse: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: snapshot.data!.docs
                                      .getRange(
                                          0, snapshot.data!.docs.length - 1)
                                      .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;
                                        String tanggal = document.id.toString();
                                        String tanggalFix =
                                            "${tanggal.substring(0, 2)} - ${tanggal.substring(2, 4)} - ${tanggal.substring(4, 8)}";
                                        return detailsContainer(tanggalFix,
                                            data["value"].toString());
                                      })
                                      .toList()
                                      .cast(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Container detailsContainer(String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(13)),
      height: 75,
      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: whiteTextStyle.copyWith(
                  fontSize: 20.0,
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    "Pengunjung total : $sub",
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container boxRectangle(String title, String body, {double height = 150}) {
    return Container(
      height: height,
      width: 150,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 24,
            ),
          ),
          Text(
            body,
            style: blackTextStyle.copyWith(
              fontSize: 40,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
