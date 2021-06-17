import 'dart:collection';

import 'package:billin_app_web/Models/dealer.dart';
import 'package:flutter/cupertino.dart';

class DealerNotifier with ChangeNotifier {
  List<Dealer> _dealerList = [];
  Dealer _currentDealer = new Dealer();

  UnmodifiableListView<Dealer> get dealerList =>
      UnmodifiableListView(_dealerList);

  Dealer get currentDealer => _currentDealer;

  set dealerList(List<Dealer> dealerList) {
    _dealerList = dealerList;
    notifyListeners();
  }

  set currentDealer(Dealer dealer) {
    _currentDealer = dealer;
    notifyListeners();
  }
}
