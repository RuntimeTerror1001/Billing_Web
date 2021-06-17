import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Models/dealer.dart';
import 'package:billin_app_web/Notifiers/dealer_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants.dart';

class DealerDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DealerNotifier dealerNotifier = Provider.of<DealerNotifier>(context);
    Dealer dealer = dealerNotifier.currentDealer;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        child: CustomAppBar(),
        preferredSize: Size.fromHeight(50),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(20),
        child: VStack(
          [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_back_outlined, color: kblueColor),
                    5.widthBox,
                    'Back to Dealer Screen'
                        .text
                        .color(kblueColor)
                        .textStyle(GoogleFonts.poppins(fontSize: 18))
                        .make()
                  ],
                ),
              ),
            ),
            30.heightBox,
            'Dealer ID : ${dealer.dealerID}'
                .text
                .semiBold
                .textStyle(GoogleFonts.poppins(fontSize: 20))
                .red500
                .makeCentered(),
            20.heightBox,
            'Name : ${dealer.name}'
                .text
                .normal
                .textStyle(GoogleFonts.poppins(fontSize: 18))
                .make(),
            5.heightBox,
            'Phone Number : ${dealer.phNum}'
                .text
                .normal
                .textStyle(GoogleFonts.poppins(fontSize: 18))
                .make(),
            5.heightBox,
            'Address : ${dealer.address}'
                .text
                .normal
                .textStyle(GoogleFonts.poppins(fontSize: 18))
                .make(),
            10.heightBox,
            Row(
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kblueColor),
                    onPressed: () {},
                    child: Text('Edit', style: TextStyle(fontSize: 18)),
                  ),
                ),
                5.widthBox,
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kremColor),
                    onPressed: () {},
                    child: Text('Delete', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: GridView.builder(
                  itemCount: dealer.billImgs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, int index) {
                    return Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(dealer
                              .billImgs[dealer.billImgs.lastIndex! - index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ],
          axisSize: MainAxisSize.min,
        ).scrollVertical(),
      ),
    );
  }
}
