import 'package:final_project/models/city.dart';
import 'package:final_project/theme.dart';
import 'package:flutter/material.dart';

class CityCard extends StatelessWidget {
  final City city;

  const CityCard(this.city);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 100,
        width: 90,
        color: const Color(0xffF6F7F8),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  city.imageUrl!,
                  width: 80,
                  height: 100,
                  fit: BoxFit.fitWidth,
                ),
                city.isPopular
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                            color: purpleColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/icon_star.png',
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              city.name!,
              style: blackTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
