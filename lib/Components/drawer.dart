import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:billin_app_web/Screens/billing_home.dart';
import 'package:billin_app_web/Screens/dealer_form.dart';
import 'package:billin_app_web/Screens/dealer_screen.dart';
import 'package:billin_app_web/Screens/stock_form.dart';
import 'package:billin_app_web/Screens/out_of_stock.dart';
import 'package:billin_app_web/Screens/stock_screen.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class NDrawer extends StatefulWidget {
  NDrawer({required this.text1, required this.onPress, required this.text2});

  final String text1;
  final String text2;
  final int onPress;
  @override
  _NDrawerState createState() => _NDrawerState();
}

class _NDrawerState extends State<NDrawer> {
  String text1 = '';
  var onPress;
  String text2 = '';

  returnAddStock() {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);
    stockNotifier.currentStock = new Stock();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new AddStock(isUpdating: false)));
  }

  returnAddDealer() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new AddDealer(isEditing: false)));
  }

  returnOutStock() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new OutOfStock()));
  }

  onPressed1() {
    if (onPress == 1) {
      return returnAddStock();
    } else if (onPress == 3) {
      return returnAddDealer();
    }
    return () {};
  }

  onPressed2() {
    if (onPress == 1) {
      return returnOutStock();
    } else if (onPress == 3) {
      return () {};
    }
    return () {};
  }

  @override
  void initState() {
    super.initState();
    text1 = widget.text1;
    text2 = widget.text2;
    onPress = widget.onPress;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              30.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  // leading: Icon(Icons.home,
                  //     color: (onPress == 1) ? Colors.red : Colors.black),
                  title: Text('Stocks',
                      style: TextStyle(
                          color: (onPress == 1) ? Colors.red : Colors.black)),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new StockScreen()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  // leading: Icon(Icons.home, color: Colors.black),
                  title: Text('Billing Section',
                      style: TextStyle(
                          color: (onPress == 2) ? Colors.red : Colors.black)),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new BillingHome()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  // leading: Icon(Icons.home, color: Colors.black),
                  title: Text('Dealers',
                      style: TextStyle(
                          color: (onPress == 3) ? Colors.red : Colors.black)),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new DealerScreen()));
                  },
                ),
              ),
              20.heightBox,
              Divider(color: kblueColor, indent: 15, endIndent: 15),
              20.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  // leading: Icon(Icons.add, color: Colors.black),
                  title: Text(text1, style: TextStyle(color: Colors.black)),
                  onTap: onPressed1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  // leading: Icon(Icons.circle, color: Colors.black),
                  title: Text(text2, style: TextStyle(color: Colors.black)),
                  onTap: onPressed2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
