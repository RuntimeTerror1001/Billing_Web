import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Dealer {
  String uid = '';
  int dealerID = 0;
  String name = '';
  String phNum = '';
  String address = '';
  List billImgs = [];
  Timestamp createdAt = Timestamp.now();
  Timestamp updatedAt = Timestamp.now();

  Dealer();

  Dealer.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    dealerID = data['dealerID'];
    name = data['name'];
    phNum = data['phNum'];
    address = data['address'];
    billImgs = data['billImgs'];
    updatedAt = data['updatedAt'];
    createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'dealerID': dealerID,
      'name': name,
      'phNum': address,
      'billImgs': billImgs,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
