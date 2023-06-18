import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/components/coustom_bottom_nav_bar.dart';
import 'package:final_project/enums.dart';
import 'package:final_project/models/admin_model.dart';
import 'package:final_project/theme.dart';
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
            SizedBox(
              height: 10,
            ),
            Text(
              "Admin",
              style: GoogleFonts.montserrat(
                  fontSize: 33,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            AspectRatio(
              aspectRatio: 335 / 250,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white),
                child: _admins(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                        SvgPicture.asset(
                          'assets/icons/add.svg',
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.admin),
    );
  }

  ListView _admins() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => _admin(admins[index]),
        separatorBuilder: (context, index) => SizedBox(
              height: 11,
            ),
        itemCount: admins.length);
  }

  Container _admin(AdminModel adminModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Color(0xFF39A848), borderRadius: BorderRadius.circular(14)),
      child: Flexible(
        fit: FlexFit.tight,
        child: Row(children: [
          Text(adminModel.name,
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          Spacer(),
          Image.asset(
            'assets/images/edit.png',
            width: 40,
          ),
          Image.asset(
            'assets/images/trash.png',
            width: 40,
          ),
        ]),
      ),
    );
  }
}
