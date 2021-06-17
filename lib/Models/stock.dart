import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  String uid = '';
  int id = 0;
  String name = '';
  double availStocks = 0.0;
  double cp = 0.0;
  double sp = 0.0;
  Timestamp updatedAt = Timestamp.now();
  Timestamp createdAt = Timestamp.now();

  Stock();

  Stock.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    availStocks = data['stock'];
    cp = data['cp'];
    sp = data['sp'];
    updatedAt = data['updatedAt'];
    createdAt = data['createdAt'];
    uid = data['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stock': availStocks,
      'cp': cp,
      'sp': sp,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'uid': uid
    };
  }
}
