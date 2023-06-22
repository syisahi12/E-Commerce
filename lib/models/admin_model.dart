import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String name;
  String email;
  String password;

  AdminModel({required this.name, required this.email, required this.password});
}

Stream<List<AdminModel>> getCashierFromFirestore() {
  return FirebaseFirestore.instance
      .collection('kasir')
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final name = doc.data()['username'] as String;
      final email = doc.data()['email'] as String;
      final password = doc.data()['password'] as String;
      return AdminModel(name: name, email: email, password: password);
    }).toList();
  });
}
