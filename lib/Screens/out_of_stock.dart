import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class OutOfStock extends StatefulWidget {
  @override
  _OutOfStockState createState() => _OutOfStockState();
}

class _OutOfStockState extends State<OutOfStock> {
  Widget bodyData(List<Stock> stocksList) => DataTable(
        showBottomBorder: true,
        headingRowColor: MaterialStateColor.resolveWith((states) => kremColor),
        headingTextStyle: GoogleFonts.poppins(fontSize: 16),
        dataTextStyle: GoogleFonts.raleway(fontSize: 15),
        columns: <DataColumn>[
          DataColumn(
            label: Text('Unique ID'),
            numeric: true,
          ),
          DataColumn(
            label: Text('Name'),
            numeric: false,
          ),
          DataColumn(
            label: Text('Available Stocks'),
            numeric: true,
          ),
        ],
        rows: stocksList
            .map((stock) => DataRow(cells: [
                  DataCell(Text('${stock.id}'),
                      showEditIcon: false, placeholder: false),
                  DataCell(Text(stock.name),
                      showEditIcon: false, placeholder: false),
                  DataCell(
                      Text(
                        '${stock.availStocks}',
                        style: TextStyle(
                            fontWeight: (stock.availStocks == 0)
                                ? FontWeight.bold
                                : FontWeight.w300,
                            color: (stock.availStocks == 0)
                                ? Colors.red[700]
                                : Colors.black),
                      ),
                      showEditIcon: false,
                      placeholder: false),
                ]))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    StockNotifier _stockNotifier =
        Provider.of<StockNotifier>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    List<Stock> finalList = [];
    finalList.addAll(_stockNotifier.stockList);
    finalList.retainWhere((stock) => stock.availStocks <= 10);

    return Scaffold(
      appBar: PreferredSize(
        child: CustomAppBar(),
        preferredSize: Size.fromHeight(50),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: VStack(
          [
            20.heightBox,
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
                    'Back to Stock Screen'
                        .text
                        .color(kblueColor)
                        .textStyle(GoogleFonts.poppins(fontSize: 18))
                        .make()
                  ],
                ),
              ),
            ),
            50.heightBox,
            Center(
              child: Container(
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.black)),
                width: 500,
                child: bodyData(finalList),
              ),
            ),
          ],
        ).scrollVertical(),
      ),
    );
  }
}
