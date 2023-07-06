import 'package:final_project/screens/payment_screen.dart';
import 'package:flutter/material.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff39A848),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Keranjang"),
          centerTitle: true,
        ),
        body: Scaffold(
          body: Column(
            children: [
              Container(
                height: 80,
                color: Colors.white,
                child: Center(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Tambah Alamat Baru",
                          style: TextStyle(color: Colors.black),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30, bottom: 10, left: 20.0, right: 20.0),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/gula.png")),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Gulaku 1kg"),
                              Text("Rp. 12.000",
                                  style: TextStyle(color: Colors.green)),
                              Text("Qty: 1"),
                            ],
                          )
                        ]),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Hapus",
                            style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Transaksi"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Qty (1 item)"),
                            Text("Rp. 12.000")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text("Harga"), Text("Rp. 12.000")],
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pembayaran()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Bayar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )));
  }
}
