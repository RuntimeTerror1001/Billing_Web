import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billin_app_web/Models/customer.dart';

class Bill {
  String billID = '';
  String url = '';
  Timestamp createdAt = Timestamp.now();
  Customer customer = Customer();

  Bill();

  Bill.fromMap(Map<String, dynamic> data) {
    billID = data['billID'];
    createdAt = data['createdAt'];
    url = data['url'];
    customer = data['customer'];
  }

  Map<String, dynamic> toMap() {
    return {
      'billID': billID,
      'url': url,
      'createdAt': createdAt,
      'customer': customer,
    };
  }
}
