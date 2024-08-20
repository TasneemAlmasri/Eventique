import 'package:eventique_company_app/color.dart';
import 'package:eventique_company_app/providers/statics_provider.dart';
import 'package:eventique_company_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _loadingAmount = false;
  int amount = 0;

  Future<void> fetchWalletAmount() async {
    try {
      setState(() {
        _loadingAmount = true;
      });
      await Provider.of<StatisticsProvider>(context, listen: false)
          .getWalletAmount();
      setState(() {
        _loadingAmount = false;
      });
    } catch (error) {
      setState(() {
        _loadingAmount = false;
      });
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWalletAmount();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    var sysBrightness = MediaQuery.of(context).platformBrightness;
    ThemeMode? themeMode = themeProvider.getThemeMode();
    bool isLight = themeMode == ThemeMode.light ||
        (sysBrightness == Brightness.light && themeMode != ThemeMode.dark);
    int moneyAmount = Provider.of<StatisticsProvider>(context).walletAmount;
    print('amount:$moneyAmount');
    return AlertDialog(
      backgroundColor: white,
      surfaceTintColor: white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'My Wallet',
            style: TextStyle(
              color: primary,
              fontSize: 24,
              fontFamily: 'IrishGrover',
            ),
          ),
          SizedBox(
            height: size.height * .04,
          ),
          SizedBox(
            height: 150,
            width: 150,
            child: Image.asset('assets/images/coins.png'),
          ),
          SizedBox(
            height: size.height * .04,
          ),
          Container(
            width: size.width * 0.8,
            height: size.height * 0.1,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: primary,
              boxShadow: [
                BoxShadow(
                  color: white,
                  offset: const Offset(
                    1.0,
                    1.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: _loadingAmount
                ? CircularProgressIndicator(
                    color: white,
                  )
                : Text(
                    moneyAmount.toString(),
                    style: TextStyle(
                      color: white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CENSCBK',
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
