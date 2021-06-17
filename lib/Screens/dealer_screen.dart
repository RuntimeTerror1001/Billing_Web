import 'package:billin_app_web/APIs/dealer_api.dart';
import 'package:billin_app_web/Components/custom_appbar.dart';
import 'package:billin_app_web/Components/dealer_card.dart';
import 'package:billin_app_web/Components/drawer.dart';
import 'package:billin_app_web/Models/dealer.dart';
import 'package:billin_app_web/Notifiers/dealer_notifier.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:billin_app_web/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billin_app_web/Components/search_box.dart';

class DealerScreen extends StatefulWidget {
  @override
  _DealerScreenState createState() => _DealerScreenState();
}

class _DealerScreenState extends State<DealerScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Dealer> dealersFiltered = [];

  @override
  void initState() {
    DealerNotifier dealerNotifier =
        Provider.of<DealerNotifier>(context, listen: false);
    getDealers(dealerNotifier);
    _searchController.addListener(() {
      filterDetails();
    });
    super.initState();
  }

  filterDetails() {
    DealerNotifier dealerNotifier =
        Provider.of<DealerNotifier>(context, listen: false);
    List<Dealer> _fDealer = [];
    _fDealer.addAll(dealerNotifier.dealerList);
    if (_searchController.text.isNotEmpty) {
      _fDealer.retainWhere((dealer) {
        String searchTerm = _searchController.text.toLowerCase();
        String dealerName = dealer.name.toString().toLowerCase();
        return dealerName.contains(searchTerm);
      });
      setState(() {
        dealersFiltered = _fDealer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DealerNotifier dealerNotifier = Provider.of<DealerNotifier>(context);
    Size size = MediaQuery.of(context).size;
    List<Dealer> finalList = [];
    if (_searchController.text.isNotEmpty) {
      setState(() {
        finalList = dealersFiltered;
      });
    } else {
      getDealers(dealerNotifier);
      setState(() {
        finalList = dealerNotifier.dealerList;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        child: CustomAppBar(),
        preferredSize: Size.fromHeight(50),
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
                text1: 'Add Dealer',
                text2: '',
                onPress: 3,
              ),
            ),
            Expanded(
              child: VStack(
                [
                  SearchBox(size: size, searchController: _searchController),
                  Container(
                    width: size.width * 0.90,
                    height: size.height * 0.80,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 15),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.38 / 0.21,
                      ),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: finalList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Dealer dealer = finalList[index];
                        // print('in grid');
                        return DealerCard(dealer: dealer);
                      },
                    ),
                  )
                ],
              ).scrollVertical(),
            ),
          ],
        ),
      ),
    );
  }
}
