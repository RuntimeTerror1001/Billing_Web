import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Components/drawer.dart';
import 'package:billin_app_web/Models/stock.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:velocity_x/velocity_x.dart';
import '../APIs/stock_api.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billin_app_web/Components/alert_pop1.dart';
import 'package:billin_app_web/Components/stock_card.dart';
import 'package:billin_app_web/Components/search_box.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Stock> stocksFiltered = [];

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

  @override
  Widget build(BuildContext context) {
    StockNotifier tstockNotifier =
        Provider.of<StockNotifier>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    AlertPop1 alertPop = new AlertPop1();
    List<Stock> finalList = [];
    if (_searchController.text.isNotEmpty) {
      setState(() {
        finalList = stocksFiltered;
      });
    } else {
      getStocks(tstockNotifier);
      setState(() {
        finalList = tstockNotifier.stockList;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Row(
          children: [
            Container(
              width: size.width * 0.18,
              color: knavColor,
              height: size.height,
              child: NDrawer(
                text1: 'Add Stock',
                text2: 'Out Of Stock',
                onPress: 1,
              ),
            ),
            VStack(
              [
                SearchBox(size: size, searchController: _searchController),
                20.heightBox,
                Container(
                  height: size.height * 0.90,
                  width: size.width * 0.80,
                  padding:
                      EdgeInsets.only(left: 15, right: 0, top: 15, bottom: 15),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.42 / 0.23,
                    ),
                    itemCount: finalList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Stock stock = finalList[index];
                      return StockCard(
                          stock: stock,
                          tstockNotifier: tstockNotifier,
                          alertPop: alertPop);
                    },
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  ),
                ),
              ],
            ).scrollVertical(),
          ],
        ),
      ),
    );
  }
}
