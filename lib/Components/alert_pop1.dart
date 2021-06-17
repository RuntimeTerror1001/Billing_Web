import 'package:flutter/material.dart';
import '../constants.dart';

enum ConfirmAction { Cancel, Delete }

class AlertPop1 {
  Future<dynamic> confirmDialog(BuildContext context,
      {required String title,
      required String content,
      required String text2,
      required String text1}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kblueColor),
                child: Text(text2),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Cancel);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kremColor,
                ),
                child: Text(text1),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Delete);
                },
              )
            ],
          );
        });
  }
}
