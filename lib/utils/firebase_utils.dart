import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HasilPencarian {
  final bool ketemu;
  final String kembalikan;

  HasilPencarian(this.ketemu, this.kembalikan);
}

class FirebaseUtils {
  final firestore = FirebaseFirestore.instance;
  final storage = const FlutterSecureStorage();
  late String dataKoleksi;

  Future login(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    HasilPencarian isKasir;
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error ${onError.toString()}"),
        duration: const Duration(seconds: 3),
      ));
      throw onError; // Rethrow the error
    });
    isKasir = await searchDocument(emailController.text, 'users', 'kasir');
    if (isKasir.ketemu) {
      return true;
    } else {
      if (isKasir.kembalikan == "null") {
        return isKasir.kembalikan;
      }
      return false;
    }
  }

  Future<HasilPencarian> searchDocument(
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
      return HasilPencarian(false, "users");
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
        return HasilPencarian(true, "kasir");
      } else {
        print('Document1 tidak ditemukan di $koleksi1 atau $koleksi2');
        return HasilPencarian(false, "null");
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

final auth = FirebaseAuth.instance;

Future<void> deleteDocumentByIndex(int index, String collectionName) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection(collectionName)
      .limit(1)
      .get();

  final documents = querySnapshot.docs;
  if (documents.length > index) {
    final documentToDelete = documents[index];
    await documentToDelete.reference.delete();
  }
}

// Menghapus pengguna dari Firebase
Future<void> deleteAccount(String email, String password) async {
  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Menghapus akun pengguna yang masuk
    await userCredential.user?.delete();

    print('Akun pengguna berhasil dihapus');
  } catch (e) {
    print('Terjadi kesalahan saat menghapus akun pengguna: $e');
  }
}

Future<UserCredential> loginByEmail(String email, String password) async {
  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } catch (e) {
    // Handle login error
    print('Error logging in: $e');
    throw e;
  }
}

Future<void> updatePassword(String newPassword) async {
  try {
    User? user = auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception('User not authenticated');
    }
  } catch (e) {
    // Handle password update error
    print('Error updating password: $e');
    throw e;
  }
}

Future<void> updateDocumentByEmail(
    String newPassword, String collection, String email) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.size > 0) {
      // Jika ditemukan dokumen dengan email yang cocok
      QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      String documentId = documentSnapshot.id;

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .update({'password': newPassword});
    } else {
      // Jika tidak ada dokumen dengan email yang cocok
      print('Document not found for email: $email');
      // Handle not found error
    }
  } catch (e) {
    // Handle document update error
    print('Error updating document: $e');
    throw e;
  }
}

class FbAddCahier {
  static Future<UserCredential> registerUser(
      String email, String password) async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  static Future<void> addKasir(
      String name, String email, String password) async {
    try {
      // Generate unique document ID
      String documentId =
          FirebaseFirestore.instance.collection('kasir').doc().id;

      // Create new document with unique ID
      await FirebaseFirestore.instance.collection('kasir').doc(documentId).set({
        'username': name,
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Error adding kasir: $e');
    }
  }
}
