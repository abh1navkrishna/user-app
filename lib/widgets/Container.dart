import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Apptext.dart';


class MyContainer extends StatelessWidget {
  const MyContainer({
    super.key,
    required this.hight,
    required this.width,
    required this.text,
  });

  final double hight;
  final double width;
  final AppText text;


  @override
  Widget build(BuildContext context) {
    return Container(
        height: hight,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(90),

        ),
        child: Center(child: text));
  }
}
