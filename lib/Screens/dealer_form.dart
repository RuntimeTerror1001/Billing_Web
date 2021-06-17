import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Models/dealer.dart';
import 'package:billin_app_web/Notifiers/dealer_notifier.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';

class AddDealer extends StatefulWidget {
  final bool isEditing;

  AddDealer({required this.isEditing});
  @override
  _AddDealerState createState() => _AddDealerState();
}

class _AddDealerState extends State<AddDealer> {
  final GlobalKey<FormState> _dealerKey = GlobalKey<FormState>();
  Dealer _currentDealer = new Dealer();
  List<int> dIDList = [];

  @override
  void initState() {
    DealerNotifier dealerNotifier =
        Provider.of<DealerNotifier>(context, listen: false);

    if (dealerNotifier.currentDealer.dealerID != null) {
      _currentDealer = dealerNotifier.currentDealer;
    } else {
      _currentDealer = Dealer();
    }
    super.initState();
  }

  int getMaxID() {
    DealerNotifier dealerNotifier =
        Provider.of<DealerNotifier>(context, listen: false);
    dealerNotifier.dealerList.forEach((dealer) {
      dIDList.add(dealer.dealerID);
    });
    return dIDList.reduce(max);
  }

  Widget _buildIDField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Dealer ID',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentDealer.dealerID.toString(),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'ID is required';
          }
          if (dIDList.contains(int.parse(value.toString()))) {
            return 'ID is already in use';
          }
          return null;
        },
        onSaved: (value) {
          _currentDealer.dealerID = int.parse(value.toString());
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
        initialValue: _currentDealer.name,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Name is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentDealer.name = value.toString();
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentDealer.phNum,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Phone Number is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentDealer.phNum = value.toString();
        },
      ),
    );
  }

  Widget _buildAddressField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Address',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: _currentDealer.address,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Address is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentDealer.address = value.toString();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.5;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(),
      ),
      body: Center(
        child: Form(
          key: _dealerKey,
          autovalidateMode: AutovalidateMode.always,
          child: VStack(
            [
              Center(
                  child:
                      (widget.isEditing ? 'Update Dealer Info' : 'Add Dealer')
                          .text
                          .xl4
                          .textStyle(GoogleFonts.raleway())
                          .make()),
              20.heightBox,
              (widget.isEditing ? '' : 'Last ID used is : ${getMaxID()}')
                  .text
                  .textStyle(GoogleFonts.poppins(fontSize: 18))
                  .red600
                  .bold
                  .make(),
              2.heightBox,
              Container(
                  width: width,
                  child: widget.isEditing
                      ? 'Dealer ID : ${_currentDealer.dealerID}'
                          .text
                          .semiBold
                          .textStyle(GoogleFonts.poppins(fontSize: 18))
                          .red500
                          .makeCentered()
                      : _buildIDField()),
              10.heightBox,
              Container(width: width, child: _buildNameField()),
              10.heightBox,
              Container(width: width, child: _buildPhoneField()),
              10.heightBox,
              Container(width: width, child: _buildAddressField()),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: kblueColor),
                      onPressed: () {},
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
          ),
        ),
      ),
    );
  }
}
