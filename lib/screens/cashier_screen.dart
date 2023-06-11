import 'package:final_project/screens/signin_screen.dart';
import 'package:final_project/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({Key? key}) : super(key: key);

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
                boxRectangle("Orders", "25"),
                boxRectangle("Buyers", "10")
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Expanded(
                    child: boxRectangle("Total IDR", "572.810", height: 100)),
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
                    fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                detailsContainer(),
                                detailsContainer(),
                                detailsContainer(),
                                detailsContainer(),
                                detailsContainer(),
                                detailsContainer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container detailsContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(13)),
      height: 65,
      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Dewa",
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
                    "Rp134.000",
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            "assets/images/done.png",
            width: 50.0,
            height: 50.0,
            fit: BoxFit.fitWidth,
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
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
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
              fontSize: 40,
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
