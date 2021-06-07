import 'package:flutter/material.dart';

import '../constants.dart';

enum ConfirmAction { Cancel, Delete }

class AlertPop {
  Future<dynamic> ConfirmDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete This Stock?'),
            content:
                const Text('This will delete the stock from your database.'),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kblueColor),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Cancel);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kremColor,
                ),
                child: const Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Delete);
                },
              )
            ],
          );
        });
  }
}
