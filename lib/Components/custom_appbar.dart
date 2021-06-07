import 'package:billin_app_web/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Text('Logo', style: TextStyle(color: kgoldenColor)),
      title: Text('Name', style: TextStyle(color: kgoldenColor)),
      centerTitle: true,
      backgroundColor: kblueColor,
    );
  }
}
