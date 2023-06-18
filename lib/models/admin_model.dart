import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String name;

  AdminModel({required this.name});
}

Future<List<AdminModel>> getAdminsFromFirestore() async {
  final adminsSnapshot =
      await FirebaseFirestore.instance.collection('kasir').get();

  final admins = adminsSnapshot.docs.map((doc) {
    final name = doc.data()['username'] as String;
    return AdminModel(name: name);
  }).toList();

  return admins;
}
