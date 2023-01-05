// ignore_for_file: invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseUtils {
  final firestore = FirebaseFirestore.instance;
  final storage = const FlutterSecureStorage();
  late String dataKoleksi;

  Future<bool> login(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    bool isKasir;
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError(
          (onError) => {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error ${onError.toString()}")))
          },
        );
    final firebaseUtils = FirebaseUtils();
    isKasir = await firebaseUtils.searchDocument(
        emailController.text, 'users', 'kasir');
    if (isKasir) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> searchDocument(
      String email, String koleksi1, String koleksi2) async {
    // Menggunakan query where() untuk mencari document di koleksi pertama
    var snapshot = await firestore
        .collection(koleksi1)
        .where('email', isEqualTo: email)
        .get();
    // Cek apakah document yang dicari ada di koleksi pertama
    if (snapshot.size > 0) {
      print('Document1 ada di $koleksi1');
      dataKoleksi = koleksi1;
      storage.write(key: 'dataKoleksi', value: dataKoleksi);
      return false;
    } else {
      // Menggunakan query where() untuk mencari document di koleksi kedua
      snapshot = await firestore
          .collection(koleksi2)
          .where('email', isEqualTo: email)
          .get();
      // Cek apakah document yang dicari ada di koleksi kedua
      if (snapshot.size > 0) {
        print('Document1 ada di $koleksi2');
        dataKoleksi = koleksi2;
        storage.write(key: 'dataKoleksi', value: dataKoleksi);
        print(dataKoleksi);
        return true;
      } else {
        print('Document1 tidak ditemukan di $koleksi1 atau $koleksi2');
        return false;
      }
    }
  }

  Widget userFire(
      {final String? firstText = '',
      final String? lastText = '',
      bool isKasir = false,
      final dataKoleksi}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(dataKoleksi)
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("");
        }
        if (snapshot.data?.docs[0] != null) {
          isKasir = true;
          return Text(
            firstText! +
                capitalize(snapshot.data?.docs[0]['username']) +
                lastText!,
            style: blackTextStyle.copyWith(
              fontSize: 24,
            ),
          );
        } else {
          isKasir = false;
          return Text(
            firstText! +
                capitalize(snapshot.data?.docs[0]['username']) +
                lastText!,
            style: blackTextStyle.copyWith(
              fontSize: 24,
            ),
          );
        }
      },
    );
  }
}
