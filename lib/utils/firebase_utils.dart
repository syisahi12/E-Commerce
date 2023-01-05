import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseUtils {
  static Future<void> login(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      Widget nextScreen) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then(
      (value) async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
    ).catchError(
      (onError) => {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error ${onError.toString()}")))
      },
    );
  }

  static Widget userFire(
      {final String? firstText = '', final String? lastText = ''}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("");
        }
        return Text(
          firstText! +
              capitalize(snapshot.data?.docs[0]['username']) +
              lastText!,
          style: blackTextStyle.copyWith(
            fontSize: 24,
          ),
        );
      },
    );
  }
}
