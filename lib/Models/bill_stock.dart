import 'package:billin_app_web/Models/stock.dart';

class BillStock {
  Map<String, dynamic> stockMap = {};
  double quantity = 0.0;
  double final_price = 0.0;

  BillStock();

  BillStock.fromMap(Map<String, dynamic> data) {
    stockMap = data['stockMap'];
    quantity = data['quantity'];
    final_price = data['final_price'];
  }

  Map<String, dynamic> toMap() {
    return {
      'stockMap': stockMap,
      'quantity': quantity,
      'final_price': final_price,
    };
  }
}
