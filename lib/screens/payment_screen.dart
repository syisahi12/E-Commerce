import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Pembayaran extends StatelessWidget {
  const Pembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Pembayaran"),
          centerTitle: true,
        ),
        body: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/qris.png")),
                                ),
                              ),
                              const Text("Qris"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/cod.png")),
                                ),
                              ),
                              const Text("Cash On Delivery"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  height: 80,
                  color: Colors.white,
                  child: const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Ambil Di Toko"), Text("Dewa")],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Qty (1 item)"),
                            Text("Rp. 12.000")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text("Delivery Fee"), Text("Info")],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
            top: 10,
            bottom: 10,
          ),
          child: ElevatedButton(
            onPressed: () {
              updateBarangByEmail("Gulaku 1kg", 12000, "users",
                  FirebaseAuth.instance.currentUser!.email!);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )));
  }
}
