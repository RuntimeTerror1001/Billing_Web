import 'dart:collection';
import 'package:billin_app_web/Models/customer.dart';
import 'package:flutter/cupertino.dart';

class CustomerBillNotifier with ChangeNotifier {
  List<Customer> _custList = [];
  Customer _currentCust = Customer();

  UnmodifiableListView<Customer> get custList =>
      UnmodifiableListView(_custList);

  Customer get currentCust => _currentCust;

  set custList(List<Customer> custList) {
    _custList = custList;
    notifyListeners();
  }

  set currentCust(Customer customer) {
    _currentCust = customer;
    notifyListeners();
  }
}
