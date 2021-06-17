import 'package:billin_app_web/Notifiers/custBill_notifier.dart';
import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Notifiers/dealer_notifier.dart';
import 'Screens/stock_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => StockNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => DealerNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => CustomerBillNotifier(),
      ),
    ],
    child: BillingApp(),
  ));
}

class BillingApp extends StatefulWidget {
  @override
  _BillingAppState createState() => _BillingAppState();
}

class _BillingAppState extends State<BillingApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme().copyWith(),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StockScreen(),
      ),
    );
  }
}
