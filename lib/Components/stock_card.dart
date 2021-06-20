import 'package:billin_app_web/APIs/stock_api.dart';
import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:billin_app_web/Screens/stock_form.dart';
import 'package:billin_app_web/Screens/stock_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'alert_pop1.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    Key? key,
    required this.stock,
    required this.tstockNotifier,
    required this.alertPop,
  }) : super(key: key);

  final Stock stock;
  final StockNotifier tstockNotifier;
  final AlertPop1 alertPop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kboxColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
              style: TextStyle(height: 1.3),
              text: 'Unique ID:    ${stock.id}\n',
              children: [
                TextSpan(text: 'Name:    ${stock.name}\n'),
                TextSpan(text: 'Available Stocks:    ${stock.availStocks}\n'),
                TextSpan(text: 'Cost Price:    ${stock.cp}\n'),
                TextSpan(text: 'Selling Price:    ${stock.sp}\n'),
              ],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120,
                  height: 25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kblueColor,
                      ),
                      onPressed: () {
                        tstockNotifier.currentStock = stock;
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new AddStock(isUpdating: true)));
                      },
                      child: Center(
                          child: Text('Update',
                              style: TextStyle(color: Colors.white)))),
                ),
                SizedBox(
                  width: 120,
                  height: 25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kremColor,
                      ),
                      onPressed: () async {
                        tstockNotifier.currentStock = stock;
                        final ConfirmAction action = await alertPop.confirmDialog(
                            context,
                            title: 'Delete ${stock.name} ?',
                            content:
                                'This will delete the stock from the database',
                            text2: 'Cancel',
                            text1: 'Delete');
                        if (action == ConfirmAction.Delete) {
                          deleteStock(stock);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockScreen()));
                        }
                      },
                      child: Center(
                          child: Text('Remove',
                              style: TextStyle(color: Colors.black)))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
