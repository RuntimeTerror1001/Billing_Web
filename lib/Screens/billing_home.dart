import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Components/drawer.dart';
import 'package:billin_app_web/Screens/create_bill.dart';
import 'package:billin_app_web/Screens/old_bills.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants.dart';

class BillingHome extends StatefulWidget {
  @override
  _BillingHomeState createState() => _BillingHomeState();
}

class _BillingHomeState extends State<BillingHome> {
  bool viewOld = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Row(
          children: [
            Container(
              width: size.width * 0.18,
              color: knavColor,
              height: size.height,
              child: NDrawer(
                text1: '',
                text2: '',
                onPress: 2,
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(2, 2),
                              blurRadius: 5)
                        ]),
                        width: 200,
                        height: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: kboxColor),
                          onPressed: () {
                            setState(() {
                              viewOld = false;
                            });
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => CreateBill()));
                          },
                          child: 'Create Bill'
                              .text
                              .textStyle(GoogleFonts.poppins(fontSize: 18))
                              .color(kblueColor)
                              .semiBold
                              .makeCentered(),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.black38,
                                  offset: Offset(2, 2),
                                  blurRadius: 5)
                            ]),
                            width: 200,
                            height: 100,
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: kboxColor),
                              onPressed: () {
                                setState(() {
                                  viewOld = true;
                                });
                              },
                              child: 'View Old Bills'
                                  .text
                                  .textStyle(GoogleFonts.poppins(fontSize: 18))
                                  .color(kblueColor)
                                  .semiBold
                                  .makeCentered(),
                            ),
                          ),
                          viewOld
                              ? Column(
                                  children: [
                                    20.heightBox,
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kremColor),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      OldBillsScreen(
                                                          last10: false)));
                                        },
                                        child: 'All Old Bills'
                                            .text
                                            .black
                                            .textStyle(GoogleFonts.poppins(
                                                fontSize: 14))
                                            .makeCentered(),
                                      ),
                                    ),
                                    20.heightBox,
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: kremColor),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      OldBillsScreen(
                                                          last10: true)));
                                        },
                                        child: 'Last 10 Bills'
                                            .text
                                            .black
                                            .textStyle(GoogleFonts.poppins(
                                                fontSize: 14))
                                            .makeCentered(),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(height: 10),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
