import 'package:billin_app_web/Models/dealer.dart';
import 'package:billin_app_web/Notifiers/dealer_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getDealers(DealerNotifier dealerNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Dealers')
      .orderBy('dealerID')
      .get();

  List<Dealer> _dealerlist = [];
  snapshot.docs.forEach((doc) {
    Map<String, dynamic> data = {
      'uid': doc.id,
      'dealerID': doc['dealerID'],
      'name': doc['name'],
      'phNum': doc['phNum'],
      'address': doc['address'],
      'billImgs': doc['billImgs'],
      'updatedAt': Timestamp.now(),
      'createdAt': Timestamp.now(),
    };
    // print(data);
    Dealer dealer = Dealer.fromMap(data);

    _dealerlist.add(dealer);
  });

  dealerNotifier.dealerList = _dealerlist;
}
