import 'package:billin_app_web/APIs/customer_api.dart';
import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Components/drawer.dart';
import 'package:billin_app_web/Components/search_box.dart';
import 'package:billin_app_web/Models/customer.dart';
import 'package:billin_app_web/Notifiers/custBill_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:billin_app_web/APIs/pdf_api.dart';
import '../constants.dart';

class OldBillsScreen extends StatefulWidget {
  @override
  _OldBillsScreenState createState() => _OldBillsScreenState();
}

class _OldBillsScreenState extends State<OldBillsScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Customer> custsFiltered = [];

  @override
  void initState() {
    super.initState();
    CustomerBillNotifier cbNotifier =
        Provider.of<CustomerBillNotifier>(context, listen: false);
    getBills(cbNotifier);
    _searchController.addListener(() {
      filterCusts();
    });
  }

  filterCusts() {
    CustomerBillNotifier cbNotifier =
        Provider.of<CustomerBillNotifier>(context, listen: false);
    List<Customer> _fCust = [];
    _fCust.addAll(cbNotifier.custList);
    if (_searchController.text.isNotEmpty) {
      _fCust.retainWhere((customer) {
        String searchTerm = _searchController.text.toLowerCase();
        String stockName = customer.name.toString().toLowerCase();
        String custBillNo = customer.billNo.toString().toLowerCase();
        return stockName.contains(searchTerm) ||
            custBillNo.contains(searchTerm);
      });
      setState(() {
        custsFiltered = _fCust;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CustomerBillNotifier _cbNotifier =
        Provider.of<CustomerBillNotifier>(context, listen: false);
    List<Customer> finalList = [];

    if (_searchController.text.isNotEmpty) {
      setState(() {
        finalList = custsFiltered;
      });
    } else {
      // getBills(_cbNotifier);
      setState(() {
        finalList = _cbNotifier.custList;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Row(
          children: [
            Container(
              width: size.width * 0.18,
              color: knavColor,
              height: size.height,
              child: NDrawer(
                text1: '',
                text2: '',
                onPress: 2,
              ),
            ),
            Expanded(
              child: Container(
                child: VStack(
                  [
                    10.heightBox,
                    'All Old Bills'
                        .text
                        .xl2
                        .textStyle(GoogleFonts.raleway())
                        .makeCentered(),
                    20.heightBox,
                    SearchBox(size: size, searchController: _searchController),
                    5.heightBox,
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OldBillsScreen()));
                        },
                        child: 'Refresh'.text.black.makeCentered()),
                    15.heightBox,
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
            ),
          ],
        ),
      ),
    );
  }
}
