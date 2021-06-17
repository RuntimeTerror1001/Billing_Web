import 'package:billin_app_web/Models/dealer.dart';
import 'package:billin_app_web/Notifiers/dealer_notifier.dart';
import 'package:billin_app_web/Screens/dealer_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class DealerCard extends StatelessWidget {
  const DealerCard({
    Key? key,
    required this.dealer,
  }) : super(key: key);

  final Dealer dealer;

  @override
  Widget build(BuildContext context) {
    DealerNotifier dealerNotifier =
        Provider.of<DealerNotifier>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: kboxColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(height: 1.3),
                text: 'Dealer ID :    ${dealer.dealerID}\n',
                children: [
                  TextSpan(text: 'Name :    ${dealer.name}\n'),
                  TextSpan(text: 'Phone No. :   +91-${dealer.phNum}\n'),
                ],
              ),
            ),
            SizedBox(
              width: 120,
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kblueColor),
                child: Center(
                    child: Text('View Details',
                        style: TextStyle(color: Colors.white))),
                onPressed: () {
                  dealerNotifier.currentDealer = dealer;
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => DealerDetails()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
