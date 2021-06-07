import 'package:billin_app_web/Components/drawer.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:billin_app_web/Screens/add_stock.dart';
import '../APIs/stock_api.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billin_app_web/Components/alert_pop.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  void initState() {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);
    getStocks(stockNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    AlertPop alertPop = new AlertPop();

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Row(
          children: [
            Container(
              width: size.width * 0.18,
              color: knavColor,
              height: size.height,
              child: NDrawer(
                text: 'Add Stock',
                onPress: 1,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.42 / 0.21,
                      ),
                      itemCount: stockNotifier.stockList.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                  text:
                                      'Unique ID:   ${stockNotifier.stockList[index].id}\n',
                                  children: [
                                    TextSpan(
                                        text:
                                            'Name:    ${stockNotifier.stockList[index].name}\n'),
                                    TextSpan(
                                        text:
                                            'Available Stocks:    ${stockNotifier.stockList[index].stock}\n'),
                                    TextSpan(
                                        text:
                                            'Cost Price:    ${stockNotifier.stockList[index].cp}\n'),
                                    TextSpan(
                                        text:
                                            'Selling Price:    ${stockNotifier.stockList[index].sp}\n'),
                                  ],
                                )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 25,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: kblueColor),
                                          onPressed: () {
                                            stockNotifier.currentStock =
                                                stockNotifier.stockList[index];
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new AddStock(
                                                            isUpdating: true)));
                                          },
                                          child: Center(child: Text('Update'))),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      height: 25,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: kremColor,
                                          ),
                                          onPressed: () async {
                                            stockNotifier.currentStock =
                                                stockNotifier.stockList[index];
                                            final ConfirmAction action =
                                                await alertPop.ConfirmDialog(
                                                    context);
                                            print("Confirm Action $action");
                                            if (action ==
                                                ConfirmAction.Delete) {
                                              deleteStock(
                                                  stockNotifier.currentStock);
                                            }
                                          },
                                          child: Center(
                                              child: Text('Remove',
                                                  style: TextStyle(
                                                      color: Colors.black)))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
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
