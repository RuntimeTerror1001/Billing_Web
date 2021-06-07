import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:billin_app_web/Screens/add_stock.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class NDrawer extends StatefulWidget {
  NDrawer({required this.text, required this.onPress});

  final String text;
  final int onPress;
  @override
  _NDrawerState createState() => _NDrawerState();
}

class _NDrawerState extends State<NDrawer> {
  String text = '';
  var onPress;

  returnAddStock() {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);
    stockNotifier.currentStock = new Stock();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new AddStock(isUpdating: false)));
  }

  onPressed() {
    if (onPress == 1) {
      return returnAddStock();
    }
    return () {};
  }

  @override
  void initState() {
    super.initState();
    text = widget.text;
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
                  leading: Icon(Icons.home, color: Colors.black),
                  title: Text('Stocks', style: TextStyle(color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.black),
                  title: Text('Billing Section',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.black),
                  title: Text('Dealers', style: TextStyle(color: Colors.black)),
                ),
              ),
              20.heightBox,
              Divider(color: kblueColor, indent: 15, endIndent: 15),
              20.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.add, color: Colors.black),
                  title: Text(text, style: TextStyle(color: Colors.black)),
                  onTap: onPressed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
