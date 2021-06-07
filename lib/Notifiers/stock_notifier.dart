import 'dart:collection';
import 'package:billin_app_web/Models/stock.dart';
import 'package:flutter/cupertino.dart';

class StockNotifier with ChangeNotifier {
  List<Stock> _stockList = [];
  Stock _currentStock = new Stock();

  UnmodifiableListView<Stock> get stockList => UnmodifiableListView(_stockList);

  Stock get currentStock => _currentStock;

  set stockList(List<Stock> stockList) {
    _stockList = stockList;
    notifyListeners();
  }

  set currentStock(Stock stock) {
    _currentStock = stock;
    notifyListeners();
  }

  deleteStock(Stock stock) {
    _stockList.removeWhere((_stock) => _stock.uid == stock.uid);
    notifyListeners();
  }
}
