import 'package:billin_app_web/APIs/stock_api.dart';
import 'package:billin_app_web/Components/alert_pop1.dart';
import 'package:billin_app_web/Components/alert_pop2.dart';
import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Components/search_box.dart';
import 'package:billin_app_web/Models/bill_stock.dart';
import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:billin_app_web/Screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants.dart';

class CreateBill extends StatefulWidget {
  @override
  _CreateBillState createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  TextEditingController _searchController = TextEditingController();
  List<Stock> stocksFiltered = [];
  List<BillStock> billStockList = [];

  @override
  void initState() {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);
    getStocks(stockNotifier);
    _searchController.addListener(() {
      filterStocks();
    });
    super.initState();
  }

  filterStocks() {
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);
    List<Stock> _fstock = [];
    _fstock.addAll(stockNotifier.stockList);
    if (_searchController.text.isNotEmpty) {
      _fstock.retainWhere((stock) {
        String searchTerm = _searchController.text.toLowerCase();
        String stockName = stock.name.toString().toLowerCase();
        return stockName.contains(searchTerm);
      });
      setState(() {
        stocksFiltered = _fstock;
      });
    }
  }

  Widget returnList(List<BillStock> billStockList) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: billStockList.length,
        itemBuilder: (context, index) {
          BillStock bStock = billStockList[index];
          Stock stock = Stock.fromMap(bStock.stockMap);
          return index == 0
              ? Column(
                  children: [
                    ListItem(
                      bStockList: billStockList,
                      index: index,
                      text1: 'Sr. No',
                      text2: 'Item Desc.',
                      text3: 'Original Price',
                      text4: 'Quantity',
                      text5: 'Final Item Cost',
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      isDelete: false,
                      delete: () {},
                    ),
                    2.heightBox,
                    ListItem(
                      bStockList: billStockList,
                      index: index,
                      text1: '${index + 1}',
                      text2: '${stock.name}',
                      text3: '${stock.sp}',
                      text4: '${bStock.quantity}',
                      text5: '${bStock.final_price}',
                      style: GoogleFonts.poppins(fontSize: 15),
                      isDelete: true,
                      delete: () {
                        setState(() {
                          billStockList.remove(bStock);
                        });
                      },
                    ),
                    2.heightBox,
                  ],
                )
              : Column(
                  children: [
                    ListItem(
                      bStockList: billStockList,
                      index: index,
                      text1: '${index + 1}',
                      text2: '${stock.name}',
                      text3: '${stock.sp}',
                      text4: '${bStock.quantity}',
                      text5: '${bStock.final_price}',
                      style: GoogleFonts.poppins(fontSize: 15),
                      isDelete: true,
                      delete: () {
                        setState(() {
                          billStockList.remove(bStock);
                        });
                      },
                    ),
                    2.heightBox,
                  ],
                );
        },
      );

  @override
  Widget build(BuildContext context) {
    BillStock bStock;
    double qty;
    double fin;
    StockNotifier stockNotifier =
        Provider.of<StockNotifier>(context, listen: true);
    Size size = MediaQuery.of(context).size;

    List<Stock> finalList = [];
    if (_searchController.text.isNotEmpty) {
      setState(() {
        finalList = stocksFiltered;
      });
    } else {
      // getStocks(stockNotifier);
      setState(() {
        finalList = stockNotifier.stockList;
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
        padding: EdgeInsets.only(top: 20),
        child: VStack([
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: size.width * 0.55,
                child: returnList(billStockList),
              ),
            ),
          ),
          10.heightBox,
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(
                  width: 120,
                  height: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: billStockList.isEmpty
                          ? Theme.of(context).disabledColor
                          : kblueColor,
                    ),
                    child: (billStockList.isEmpty
                            ? 'No Items'
                            : 'Finalize Bill')
                        .text
                        .color(
                            billStockList.isEmpty ? Colors.black : Colors.white)
                        .makeCentered(),
                    onPressed: billStockList.isEmpty
                        ? null
                        : () async {
                            AlertPop1 alertPop = new AlertPop1();
                            final ConfirmAction action =
                                await alertPop.confirmDialog(context,
                                    title: 'Finalize Bill?',
                                    content:
                                        'This will affect your stocks.You will not be able to go back after this step.',
                                    text2: 'Finalize Bill',
                                    text1: 'Cancel');
                            if (action == ConfirmAction.Cancel) {
                              billStockList.forEach((billStock) {
                                Stock _stock =
                                    Stock.fromMap(billStock.stockMap);
                                _stock.availStocks -= billStock.quantity;
                                uploadStocks(_stock, true);
                                // print(billStock.stock.availStocks);
                              });
                            }
                            billStockList.retainWhere(
                                (element) => element.quantity != 0);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => BillForm(
                                        billStockList: billStockList)));
                          },
                  ),
                ),
                20.widthBox,
                SizedBox(
                  width: 120,
                  height: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kremColor,
                    ),
                    child: 'Cancel'.text.color(Colors.black).makeCentered(),
                    onPressed: () async {
                      AlertPop1 alertPop = new AlertPop1();
                      final ConfirmAction action = await alertPop.confirmDialog(
                          context,
                          title: 'Cancel Billing Process?',
                          content:
                              'This will take you back to Billing Home Screen',
                          text2: 'Create Bill',
                          text1: 'Yes, Cancel');
                      if (action == ConfirmAction.Delete) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ])),
          Center(
            child: SearchBox(size: size, searchController: _searchController),
          ),
          Center(
            child: Container(
              width: size.width * 0.90,
              height: size.height * 0.70,
              padding: EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.28 / 0.15,
                ),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: finalList.length,
                itemBuilder: (BuildContext context, int index) {
                  Stock stock = finalList[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: kboxColor,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(
                              style: TextStyle(height: 1.2, fontSize: 15),
                              text: 'Name:    ${stock.name}\n',
                              children: [
                                TextSpan(
                                    text:
                                        'Available Stocks:    ${stock.availStocks}\n'),
                                TextSpan(
                                    text: 'Selling Price:    ${stock.sp}\n'),
                              ],
                            )),
                            // 3.heightBox,
                            SizedBox(
                              width: 120,
                              height: 25,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: stock.availStocks == 0
                                      ? Theme.of(context).disabledColor
                                      : kblueColor,
                                ),
                                child: (stock.availStocks == 0
                                        ? 'No Stock'
                                        : 'Add to Bill')
                                    .text
                                    .color(stock.availStocks == 0
                                        ? Colors.black
                                        : Colors.white)
                                    .makeCentered(),
                                onPressed: stock.availStocks == 0
                                    ? null
                                    : () async {
                                        AlertPop2 ap2 = AlertPop2();
                                        qty = await ap2.inputDialog(
                                            context, stock);
                                        fin = qty * stock.sp;
                                        // print(qty);
                                        bStock = BillStock.fromMap({
                                          'stockMap': stock.toMap(),
                                          'quantity': qty,
                                          'final_price': fin,
                                        });
                                        setState(() {
                                          billStockList.add(bStock);
                                        });
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ]).scrollVertical(),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.bStockList,
    required this.index,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.style,
    required this.isDelete,
    required this.delete,
  }) : super(key: key);

  final List<BillStock> bStockList;
  final int index;
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final TextStyle style;
  final bool isDelete;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        color: isDelete ? Colors.transparent : kremColor,
        height: isDelete ? 25 : 35,
        child: Row(
          children: [
            Expanded(child: Text(text1, style: style)),
            Expanded(child: Text(text2, style: style)),
            Expanded(child: Text(text3, style: style)),
            Expanded(child: Text(text4, style: style)),
            Expanded(child: Text(text5, style: style)),
            Expanded(
                child: isDelete
                    ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          delete();
                        },
                      )
                    : Text(''))
          ],
        ),
      ),
    );
  }
}
