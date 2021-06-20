import 'package:billin_app_web/APIs/customer_api.dart';
import 'package:billin_app_web/APIs/pdf_api.dart';
import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Models/bill_stock.dart';
import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/custBill_notifier.dart';
import 'package:billin_app_web/Screens/billing_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:billin_app_web/Models/customer.dart';
import '../constants.dart';

class BillForm extends StatefulWidget {
  BillForm({required this.billStockList});

  final List<BillStock> billStockList;
  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  final GlobalKey<FormState> _billKey = GlobalKey<FormState>();
  Customer customer = Customer();
  bool isSaved = false;
  String prevID = '';
  List<String> prevBillNoList = [];

  Widget _buildBillNoField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Bill Number',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        initialValue: '${DateFormat.yMd().format(DateTime.now())}-',
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Bill No is required';
          }
          return null;
        },
        onSaved: (value) {
          customer.billNo = value.toString();
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
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Name is required';
          }
          if (prevBillNoList.contains(value)) {
            return 'Bill ID is already used';
          }
          return null;
        },
        onSaved: (value) {
          customer.name = value.toString();
        },
      ),
    );
  }

  Widget _buildNumField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Phone Number is required';
          }
          return null;
        },
        onSaved: (value) {
          customer.phNum = value.toString();
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
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Address is required';
          }
          return null;
        },
        onSaved: (value) {
          customer.cAddress = value.toString();
        },
      ),
    );
  }

  Widget _buildDiscField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Discount',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        initialValue: '0',
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return 'Discount is required';
          }
          return null;
        },
        onSaved: (value) {
          customer.percOff = double.parse(value.toString());
        },
      ),
    );
  }

  Widget _buildPayMethIP() {
    String val = 'Online';
    return Padding(
      padding: EdgeInsets.all(10),
      child: DropdownButtonFormField(
        value: val,
        onSaved: (meth) {
          customer.payMeth = meth.toString();
        },
        onChanged: (newValue) {
          setState(() {
            val = newValue.toString();
          });
        },
        decoration: InputDecoration(
            labelText: 'Payment Method',
            labelStyle: TextStyle(fontSize: 20, height: 0.6)),
        items: [
          DropdownMenuItem(
            value: 'Online',
            child: 'Online'.text.makeCentered(),
          ),
          DropdownMenuItem(
            value: 'Cash',
            child: 'Cash'.text.makeCentered(),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildRowList(List<BillStock> billStockList) {
    List<DataRow> rowList = [];
    widget.billStockList.forEach((bStock) {
      Stock _stock = Stock.fromMap(bStock.stockMap);
      rowList.add(DataRow(cells: <DataCell>[
        DataCell(Center(
          child: Text('${billStockList.indexOf(bStock) + 1}'),
        )),
        DataCell(Center(child: Text(_stock.name))),
        DataCell(Center(child: Text('${_stock.sp}'))),
        DataCell(Center(child: Text('${bStock.quantity}'))),
        DataCell(Center(child: Text('${bStock.final_price}'))),
      ]));
    });
    return rowList;
  }

  Widget dataTable() => DataTable(
        showBottomBorder: true,
        headingRowColor: MaterialStateColor.resolveWith((states) => kremColor),
        headingTextStyle: GoogleFonts.poppins(fontSize: 15),
        dataTextStyle: GoogleFonts.raleway(fontSize: 14),
        columns: <DataColumn>[
          DataColumn(label: Text('Sr No'), numeric: false),
          DataColumn(label: Text('Item Desc.'), numeric: false),
          DataColumn(label: Text('Original Price'), numeric: false),
          DataColumn(label: Text('Quantity'), numeric: false),
          DataColumn(label: Text('Final Item Cost'), numeric: false),
        ],
        rows: _buildRowList(widget.billStockList),
      );

  @override
  void initState() {
    CustomerBillNotifier cbNotifier =
        Provider.of<CustomerBillNotifier>(context, listen: false);
    getBills(cbNotifier);
    prevID = cbNotifier.custList.first.billNo;
    cbNotifier.custList.forEach((customer) {
      prevBillNoList.add(customer.billNo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> billMapList = [];
    widget.billStockList.forEach((billStock) {
      billMapList.add(billStock.toMap());
    });
    customer.itemList = billMapList;

    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.5;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Form(
        key: _billKey,
        autovalidateMode: AutovalidateMode.always,
        child: VStack(
          [
            10.heightBox,
            20.heightBox,
            Center(
                child: 'Customer Info'
                    .text
                    .xl4
                    .textStyle(GoogleFonts.raleway())
                    .make()),
            20.heightBox,
            prevID != ''
                ? Container(
                    width: width,
                    child: 'Previous Bill No : $prevID'
                        .text
                        .semiBold
                        .textStyle(GoogleFonts.poppins(fontSize: 18))
                        .red500
                        .makeCentered(),
                  )
                : Container(),
            10.heightBox,
            Container(width: width, child: _buildBillNoField()),
            10.heightBox,
            Container(width: width, child: _buildNameField()),
            10.heightBox,
            Container(width: width, child: _buildNumField()),
            10.heightBox,
            Container(width: width, child: _buildAddressField()),
            10.heightBox,
            Container(width: width, child: _buildDiscField()),
            10.heightBox,
            Container(width: width, child: _buildPayMethIP()),
            25.heightBox,
            dataTable(),
            20.heightBox,
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kblueColor),
                onPressed: () {
                  if (!(_billKey.currentState!.validate())) {
                    return;
                  }
                  _billKey.currentState!.save();
                  setState(() {
                    isSaved = true;
                    customer.calculate();
                    // print(customer.total);
                  });
                },
                child: Text('See Total', style: TextStyle(fontSize: 18)),
              ),
            ),
            20.heightBox,
            isSaved == true
                ? Column(
                    children: [
                      'Subtotal : ${customer.subTotal}'
                          .text
                          .textStyle(GoogleFonts.raleway(fontSize: 20))
                          .makeCentered(),
                      15.heightBox,
                      'Discounted Price : ${customer.discPrice}'
                          .text
                          .textStyle(GoogleFonts.raleway(fontSize: 20))
                          .makeCentered(),
                      15.heightBox,
                      'Total(Inc. taxes) : ${customer.total}'
                          .text
                          .textStyle(GoogleFonts.raleway(fontSize: 20))
                          .makeCentered(),
                      20.heightBox,
                    ],
                  )
                : 20.heightBox,
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kblueColor),
                onPressed: () async {
                  uploadBills(customer);
                  await PdfApi.generatePDF(customer);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BillingHome()));
                },
                child: Text('Generate Bill', style: TextStyle(fontSize: 18)),
              ),
            ),
            50.heightBox,
          ],
          crossAlignment: CrossAxisAlignment.center,
        ).scrollVertical(),
      ),
    );
  }
}
