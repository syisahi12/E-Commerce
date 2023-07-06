import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/signin_screen.dart';
import 'package:final_project/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({Key? key}) : super(key: key);

  @override
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Kasir",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => FirebaseAuth.instance.signOut().then(
                (value) => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                ),
              ),
        ),
      ),
      body: Container(
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
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Terjadi kesalahan: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final int orderCount = snapshot.data!.docs.length;

                    return boxRectangle("Orders", orderCount.toString(),
                        height: MediaQuery.of(context).size.height / 7);
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('orders')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Terjadi kesalahan: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    final Set<String> uniqueUsernames = {};

                    for (var document in documents) {
                      final username = document['username'] as String?;
                      if (username != null) {
                        uniqueUsernames.add(username);
                      }
                    }

                    final int totalBuyers = uniqueUsernames.length;

                    return boxRectangle("Buyers", totalBuyers.toString(),
                        height: MediaQuery.of(context).size.height / 7);
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Terjadi kesalahan: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;
                      int totalHarga = 0;
                      for (var doc in documents) {
                        final harga = doc['harga'] as int;
                        totalHarga += harga;
                      }

                      return boxRectangle("Total IDR", "Rp $totalHarga",
                          height: MediaQuery.of(context).size.height / 7);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                "List Order",
                style: whiteTextStyle.copyWith(
                    fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height / 2.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Details",
                        style: blackTextStyle.copyWith(fontSize: 24.0),
                      ),
                      Text(
                        "Confirm",
                        style: blackTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.36,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Terjadi kesalahan: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          final List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          final List<Widget> containerList = [];
                          for (var document in documents) {
                            final harga = document['harga'];

                            if (harga > 0) {
                              containerList.add(
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: detailsContainer(document),
                                ),
                              );
                            }
                          }
                          return SingleChildScrollView(
                            child: Column(
                              children: containerList,
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container detailsContainer(DocumentSnapshot document) {
    final nama = document['username'];
    final harga = document['harga'];
    final docRef =
        FirebaseFirestore.instance.collection('users').doc(document.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(13),
      ),
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                nama,
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
                    'Rp $harga',
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              final collectionRef =
                  FirebaseFirestore.instance.collection('orders');

              final snapshot = await collectionRef.get();
              final int orderCount = snapshot.docs.length;

              await collectionRef.add({
                'orderId': '${orderCount + 1}',
                'username': nama,
                'harga': harga,
              });

              await docRef.update({'harga': 0});
            },
            child: Image.asset(
              'assets/images/done.png',
              width: 40,
            ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
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
              fontSize: 30,
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
