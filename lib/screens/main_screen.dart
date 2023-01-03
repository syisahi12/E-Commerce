// ignore_for_file: implementation_imports, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_project/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_card/src/image_card_content.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOKI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Produk Baru",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25.0,
            ),
            FillImageCard(
              width: 150,
              heightImage: 150,
              imageProvider: AssetImage('assets/images/gula.png'),
              tagSpacing: 30,
              tags: [Text('Harga :'), Text('Rp19.000')],
              title: Text(
                'Gulaku',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              description: Text(
                'Ini gula yang sangat manis',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FillImageCard extends StatelessWidget {
  const FillImageCard({
    Key? key,
    this.width,
    this.height,
    this.heightImage,
    this.borderRadius = 6,
    this.contentPadding,
    required this.imageProvider,
    this.tags,
    this.title,
    this.description,
    this.footer,
    this.color = Colors.white,
    this.tagSpacing,
    this.tagRunSpacing,
  }) : super(key: key);

  /// card width
  final double? width;

  /// card height
  final double? height;

  /// image height
  final double? heightImage;

  /// border radius value
  final double borderRadius;

  /// spacing between tag
  final double? tagSpacing;

  /// run spacing between line tag
  final double? tagRunSpacing;

  /// content padding
  final EdgeInsetsGeometry? contentPadding;

  /// image provider
  final ImageProvider imageProvider;

  /// list of widgets
  final List<Widget>? tags;

  /// card color
  final Color color;

  /// widget title of card
  final Widget? title;

  /// widget description of card
  final Widget? description;

  /// widget footer of card
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              child: Image(
                image: imageProvider,
                width: width,
                height: heightImage,
                fit: BoxFit.fitWidth,
              ),
            ),
            ImageCardContent(
              contentPadding: contentPadding,
              tags: tags,
              title: title,
              footer: footer,
              description: description,
              tagSpacing: tagSpacing,
              tagRunSpacing: tagRunSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckOut()),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
