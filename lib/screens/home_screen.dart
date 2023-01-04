import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/checkout_screen.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email',
                        isEqualTo: FirebaseAuth.instance.currentUser?.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("");
                  }
                  return Text(snapshot.data?.docs[0]['username']);
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance
                          .signOut()
                          .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInScreen()),
                              ));
                    },
                    child: const Text("LogOut"),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                      );
                    },
                    child: const Text("Utama"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
