import 'package:billin_app_web/Models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billin_app_web/Notifiers/custBill_notifier.dart';

uploadBills(Customer customer) async {
  CollectionReference billRef =
      FirebaseFirestore.instance.collection('CustBills');
  customer.createdAt = Timestamp.now();
  DocumentReference documentReference = await billRef.add(customer.toMap());
  await documentReference.set(customer.toMap(), SetOptions(merge: true));
}

getBills(CustomerBillNotifier cbNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('CustBills')
      .orderBy('createdAt', descending: true)
      .get();

  List<Customer> _custList = [];

  snapshot.docs.forEach((doc) {
    Map<String, dynamic> data = {
      'name': doc['name'],
      'phNum': doc['phNum'],
      'cAddress': doc['cAddress'],
      'payMeth': doc['payMeth'],
      'percOff': doc['percOff'],
      'itemList': doc['itemList'],
      'subTotal': doc['subTotal'],
      'discPrice': doc['discPrice'],
      'total': doc['total'],
      'billNo': doc['billNo'],
      'createdAt': doc['createdAt'],
    };

    Customer customer = Customer.fromMap(data);

    _custList.add(customer);
  });

  cbNotifier.custList = _custList;
  print('notifier ${cbNotifier.custList}');
  // cbNotifier.custList.forEach((element) {
  //   print(element.billNo);
  // });
}
