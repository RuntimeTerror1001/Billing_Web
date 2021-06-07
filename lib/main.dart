import 'package:billin_app_web/Notifiers/stock_notifier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Components/custom_appbar.dart';
import 'Screens/stock_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => StockNotifier(),
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(),
        ),
        body: StockScreen(),
      ),
    );
  }
}
