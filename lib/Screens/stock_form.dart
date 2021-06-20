import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:billin_app_web/Screens/stock_screen.dart';
import '../APIs/stock_api.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Models/stock.dart';
import 'dart:math';

class AddStock extends StatefulWidget {
  final bool isUpdating;

  AddStock({required this.isUpdating});
  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final GlobalKey<FormState> _stockKey = GlobalKey<FormState>();
  Stock _currentStock = new Stock();
  List<int> idList = [];

  @override
  void initState() {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);

    if (stockNotifier.currentStock.id != null) {
      _currentStock = stockNotifier.currentStock;
    } else {
      _currentStock = Stock();
    }
    super.initState();
  }

  int getMaxID() {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);
    stockNotifier.stockList.forEach((stock) {
      idList.add(stock.id);
    });
    return idList.reduce(max);
  }

  Widget _buildIDField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Unique ID',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentStock.id.toString(),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'ID is required';
          }
          if (idList.contains(int.parse(value.toString()))) {
            return 'ID is already in use';
          }
          if (int.parse(value!) < 0) {
            return 'ID cannot be negative';
          }
          return null;
        },
        onSaved: (value) {
          _currentStock.id = int.parse(value.toString());
        },
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentStock.name,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Name is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentStock.name = value.toString();
        },
      ),
    );
  }

  Widget _buildStockField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Available Stocks',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentStock.availStocks.toString(),
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Stock is required';
          }
          if (int.parse(value!) < 0) {
            return 'Stock cannot be negative';
          }
          return null;
        },
        onSaved: (value) {
          _currentStock.availStocks = double.parse(value.toString());
        },
      ),
    );
  }

  Widget _buildCPField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Cost Price',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentStock.cp.toString(),
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Cost Price is required';
          }
          if (int.parse(value!) < 0) {
            return 'Cost Price cannot be negative';
          }
          return null;
        },
        onSaved: (value) {
          _currentStock.cp = double.parse(value.toString());
        },
      ),
    );
  }

  Widget _buildSPField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Selling Price',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentStock.sp.toString(),
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Selling Price is required';
          }
          if (int.parse(value!) < 0) {
            return 'Selling Price cannot be negative';
          }
          return null;
        },
        onSaved: (value) {
          _currentStock.sp = double.parse(value.toString());
        },
      ),
    );
  }

  _saveStock() {
    if (!(_stockKey.currentState!.validate())) {
      _stockKey.currentState!.reset();
      return '';
    }
    _stockKey.currentState!.save();

    uploadStocks(_currentStock, widget.isUpdating);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.5;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Form(
        key: _stockKey,
        autovalidateMode: AutovalidateMode.always,
        child: VStack(
          [
            10.heightBox,
            Center(
                child: (widget.isUpdating ? 'Update Stock' : 'Add Stock')
                    .text
                    .xl4
                    .textStyle(GoogleFonts.raleway())
                    .make()),
            20.heightBox,
            (widget.isUpdating ? '' : 'Last ID used is : ${getMaxID()}')
                .text
                .textStyle(GoogleFonts.poppins(fontSize: 18))
                .red600
                .bold
                .make(),
            2.heightBox,
            Container(
                width: width,
                child: widget.isUpdating
                    ? 'Unique ID : ${_currentStock.id}'
                        .text
                        .semiBold
                        .textStyle(GoogleFonts.poppins(fontSize: 18))
                        .red500
                        .makeCentered()
                    : _buildIDField()),
            10.heightBox,
            Container(width: width, child: _buildNameField()),
            10.heightBox,
            Container(width: width, child: _buildStockField()),
            10.heightBox,
            Container(width: width, child: _buildCPField()),
            10.heightBox,
            Container(width: width, child: _buildSPField()),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kblueColor),
                    onPressed: () => _saveStock().then(Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StockScreen()))),
                    child: Text('Save', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kremColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
          crossAlignment: CrossAxisAlignment.center,
        ).scrollVertical(),
      ),
    );
  }
}
