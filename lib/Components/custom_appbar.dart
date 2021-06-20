import 'package:billin_app_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: Text('Logo', style: TextStyle(color: kgoldenColor)),
      leading: Container(),
      title: Text('Darshan Collections and Men\'s Wear',
          style: GoogleFonts.lobsterTwo(color: kgoldenColor, fontSize: 25)),
      centerTitle: true,
      backgroundColor: kblueColor,
    );
  }
}
