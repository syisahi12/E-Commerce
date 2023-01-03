import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var dataName;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    dispName();
  }

  dispName() async {
    Query<Map<String, dynamic>> docRef = await FirebaseFirestore.instance
        .collection('users')
        .where('email',
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString());
    docRef.get().then((doc) async {
      dataName = await doc.docs[0]['username'];
    });
    setState(() {
      dataName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Halo, ${FirebaseAuth.instance.currentUser?.email.toString()}\n${dataName}"),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    ));
              },
              child: const Text("LogOut"),
            ),
          ],
        ),
      ),
    );
  }
}
