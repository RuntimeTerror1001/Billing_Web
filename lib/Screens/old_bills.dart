import 'package:billin_app_web/APIs/customer_api.dart';
import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Models/customer.dart';
import 'package:billin_app_web/Notifiers/custBill_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:billin_app_web/APIs/pdf_api.dart';

import '../constants.dart';

class OldBillsScreen extends StatefulWidget {
  final bool last10;
  OldBillsScreen({required this.last10});
  @override
  _OldBillsScreenState createState() => _OldBillsScreenState();
}

class _OldBillsScreenState extends State<OldBillsScreen> {
  bool last10 = false;
  List<Customer> _lastTen = [];

  @override
  void initState() {
    last10 = widget.last10;
    CustomerBillNotifier cbNotifier =
        Provider.of<CustomerBillNotifier>(context, listen: false);
    getBills(cbNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CustomerBillNotifier _cbNotifier =
        Provider.of<CustomerBillNotifier>(context, listen: false);
    List<Customer> finalList = [];

    _lastTen.addAll(_cbNotifier.custList);
    _lastTen
        .retainWhere((element) => _cbNotifier.custList.indexOf(element) <= 10);
    print(_lastTen);

    if (last10 == true) {
      setState(() {
        finalList = _lastTen;
      });
    } else {
      setState(() {
        finalList = _cbNotifier.custList;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: VStack(
          [
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_back_outlined, color: kblueColor),
                    5.widthBox,
                    'Back'
                        .text
                        .color(kblueColor)
                        .textStyle(GoogleFonts.poppins(fontSize: 18))
                        .make()
                  ],
                ),
              ),
            ),
            10.heightBox,
            (widget.last10 ? 'Last 10 Bills' : 'All Old Bills')
                .text
                .xl2
                .textStyle(GoogleFonts.raleway())
                .makeCentered(),
            20.heightBox,
            Center(
              child: Container(
                width: 400,
                height: 500,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: finalList.length,
                  itemBuilder: (context, index) {
                    Customer customer = finalList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          tileColor: Color(0xFFE3E3E3),
                          leading: Text(customer.billNo,
                              style: TextStyle(color: Colors.black)),
                          title: Text(customer.name,
                              style: TextStyle(color: Colors.black)),
                          subtitle: Text('Rs. ${customer.total}',
                              style: TextStyle(color: Colors.black)),
                          contentPadding: EdgeInsets.all(10),
                          onTap: () async {
                            await PdfApi.generatePDF(customer);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ).scrollVertical(),
      ),
    );
  }
}
