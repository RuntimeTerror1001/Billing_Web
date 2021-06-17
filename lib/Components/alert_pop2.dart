import 'package:billin_app_web/Models/stock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants.dart';

class AlertPop2 {
  Future<dynamic> inputDialog(BuildContext context, Stock stock) async {
    TextEditingController _qtyController = TextEditingController();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add ${stock.name}\nEnter Quantity:'),
          backgroundColor: kboxColor,
          content: TextField(
            controller: _qtyController,
          ),
          actions: <Widget>[
            SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kblueColor),
                onPressed: () {
                  Navigator.pop(
                      context, double.parse(_qtyController.text.toString()));
                },
                child: 'Done'.text.color(Colors.white).makeCentered(),
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kremColor),
                onPressed: () {
                  Navigator.pop(context, 0.0);
                },
                child: 'Cancel'.text.color(Colors.black).makeCentered(),
              ),
            ),
          ],
        );
      },
    );
  }
}
