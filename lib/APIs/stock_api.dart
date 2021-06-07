import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getStocks(StockNotifier stockNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Stocks').orderBy('id').get();

  List<Stock> _stocklist = [];

  snapshot.docs.forEach((doc) {
    Map<String, dynamic> data = {
      'id': doc['id'],
      'name': doc['name'],
      'stock': doc['stock'],
      'cp': doc['cp'],
      'sp': doc['sp'],
      'updatedAt': Timestamp.now(),
      'createdAt': Timestamp.now(),
      'uid': doc.id,
    };
    // print(data);

    Stock stock = Stock.fromMap(data);

    _stocklist.add(stock);
  });

  stockNotifier.stockList = _stocklist;
}

uploadStocks(Stock stock, bool isUpdating) async {
  CollectionReference stockRef =
      FirebaseFirestore.instance.collection('Stocks');

  if (isUpdating) {
    stock.updatedAt = Timestamp.now();
    await stockRef.doc(stock.uid.toString()).update(stock.toMap());
  } else {
    stock.createdAt = Timestamp.now();
    DocumentReference documentReference = await stockRef.add(stock.toMap());
    stock.uid = documentReference.id;
    await documentReference.set(stock.toMap(), SetOptions(merge: true));
  }
}

deleteStock(Stock stock) async {
  await FirebaseFirestore.instance.collection('Stocks').doc(stock.uid).delete();
}
