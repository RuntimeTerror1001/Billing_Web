import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  int id = 0;
  String name = '';
  int stock = 0;
  double cp = 0.0;
  double sp = 0.0;
  String uid = '';
  Timestamp updatedAt = Timestamp.now();
  Timestamp createdAt = Timestamp.now();

  Stock();

  Stock.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    stock = data['stock'];
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
      'stock': stock,
      'cp': cp,
      'sp': sp,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'uid': uid
    };
  }
}
