import 'package:final_project/components/coustom_bottom_nav_bar.dart';
import 'package:final_project/enums.dart';
import 'package:final_project/models/admin_model.dart';
import 'package:final_project/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Admin",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.green),
        child: Column(
          children: [
            const SizedBox(
              height: 140,
            ),
            SvgPicture.asset(
              'assets/icons/profil.svg',
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Admin",
              style: GoogleFonts.montserrat(
                  fontSize: 33,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            AspectRatio(
              aspectRatio: 335 / 250,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white),
                child: StreamBuilder<List<AdminModel>>(
                  stream: getCashierFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cashiersDatas = snapshot.data!;

                      return _admins(cashiersDatas);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddKasirPopup();
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Text("Add Kasir",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2)),
                          SvgPicture.asset(
                            'assets/icons/add.svg',
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.admin),
    );
  }

  ListView _admins(List<AdminModel> cashier) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => _admin(cashier[index], index),
      separatorBuilder: (context, index) => const SizedBox(
        height: 11,
      ),
      itemCount: cashier.length,
    );
  }

  Container _admin(AdminModel adminModel, int index) {
    TextEditingController newPasswordController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: const Color(0xFF39A848),
          borderRadius: BorderRadius.circular(14)),
      child: Flexible(
        fit: FlexFit.tight,
        child: Row(children: [
          Text(adminModel.name,
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          const Spacer(),
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Data'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: newPasswordController,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text('Save'),
                          onPressed: () async {
                            // Ambil email dan password dari Firestore
                            String email = adminModel.email;
                            String password = adminModel.password;

                            // Login dengan email dan password
                            await loginByEmail(email, password);

                            // Ganti password
                            String newPassword = newPasswordController.text;
                            await updatePassword(newPassword);

                            // Update password di Firestore
                            adminModel.password = newPassword;
                            await updateDocumentByEmail(
                              newPassword,
                              'kasir',
                              adminModel.email,
                            );

                            // Tutup dialog
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Image.asset(
                'assets/images/edit.png',
                width: 40,
              ),
            );
          }),
          GestureDetector(
            onTap: () async {
              await deleteDocumentByIndex(index, "kasir");
              await deleteAccount(adminModel.email, adminModel.password);
            },
            child: Image.asset(
              'assets/images/trash.png',
              width: 40,
            ),
          ),
        ]),
      ),
    );
  }
}

class AddKasirPopup extends StatefulWidget {
  @override
  _AddKasirPopupState createState() => _AddKasirPopupState();
}

class _AddKasirPopupState extends State<AddKasirPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> handleAddKasir() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // Register user with email and password
      FbAddCahier.registerUser(email, password);

      // Add kasir to Firestore
      await FbAddCahier.addKasir(name, email, password);

      // Clear text fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();

      // Close the dialog
      Navigator.of(context).pop();
    } catch (e) {
      print('Error adding kasir: $e');
      // Show error message or take appropriate action
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Kasir'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Add'),
          onPressed: handleAddKasir,
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            // Clear text fields
            nameController.clear();
            emailController.clear();
            passwordController.clear();

            // Close the dialog
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
