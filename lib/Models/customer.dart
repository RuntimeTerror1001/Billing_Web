import 'package:billin_app_web/Models/bill_stock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String name = '';
  String phNum = '';
  String cAddress = '';
  String payMeth = '';
  double percOff = 0.0;
  List itemList = [];
  double subTotal = 0.0;
  double discPrice = 0.0;
  double total = 0.0;
  String billNo = '';
  Timestamp createdAt = Timestamp.now();

  Customer();

  Customer.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    phNum = data['phNum'];
    cAddress = data['cAddress'];
    payMeth = data['payMeth'];
    percOff = data['percOff'];
    itemList = data['itemList'];
    subTotal = data['subTotal'];
    discPrice = data['discPrice'];
    total = data['total'];
    billNo = data['billNo'];
    createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phNum': phNum,
      'cAddress': cAddress,
      'payMeth': payMeth,
      'percOff': percOff,
      'itemList': itemList,
      'subTotal': subTotal,
      'discPrice': discPrice,
      'total': total,
      'billNo': billNo,
      'createdAt': createdAt,
    };
  }

  calculate() {
    List<double> priceList = [];
    this.itemList.forEach((element) {
      BillStock bStock = BillStock.fromMap(element);
      priceList.add(bStock.final_price);
    });
    this.subTotal = priceList.reduce((value, element) => value + element);
    this.discPrice = this.subTotal - ((this.percOff / 100) * this.subTotal);
    this.total = this.discPrice + (5 / 100 * this.discPrice);
  }
}
