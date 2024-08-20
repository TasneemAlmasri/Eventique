import 'package:eventique/providers/theme_provider.dart';
import 'package:eventique/providers/wallet_provider.dart';
import 'package:eventique/widgets/wallet/add_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/color.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet';

  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _loadingSubmit = false;
  bool _loadingWalletAmount = false;
  int amount = 0;

  void _submitForm(
    int amount,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _loadingSubmit = true;
      });
      await Provider.of<WalletProvider>(context, listen: false)
          .AddToWallet(amount);

      setState(() {
        _loadingSubmit = false;
      });
      fetchWalletAmount();
    } catch (error) {
      print(error.toString());
      setState(() {
        _loadingSubmit = false;
      });
    }
  }

  Future<void> fetchWalletAmount() async {
    try {
      setState(() {
        _loadingWalletAmount = true;
      });
      await Provider.of<WalletProvider>(context, listen: false)
          .getWalletAmount();
      setState(() {
        _loadingWalletAmount = false;
      });
    } catch (error) {
      setState(() {
        _loadingWalletAmount = false;
      });
      print(error);
    }
  }

  @override
  void initState() {
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
    int moneyAmount = Provider.of<WalletProvider>(context).walletAmount;
    return Scaffold(
      backgroundColor: isLight ? white : darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? white : darkBackground,
        shape: Border(
          bottom: BorderSide(
            color: isLight ? primary : white,
            width: 1.6,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'My wallet',
            style: TextStyle(
              color: isLight ? primary : white,
              fontSize: 24,
              fontFamily: 'IrishGrover',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              height: size.height * 0.26,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primary,
                boxShadow: const [
                  BoxShadow(
                    color: white,
                    offset: Offset(
                      1.0,
                      1.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Avaliable balance',
                          style: TextStyle(
                              fontFamily: 'CENSCBK',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                        _loadingWalletAmount
                            ? const CircularProgressIndicator()
                            : Text(
                                '$moneyAmount   S.P',
                                style: const TextStyle(
                                    fontFamily: 'CENSCBK',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                      ],
                    ),
                    SizedBox(
                        width: 75,
                        height: 75,
                        child: Image.asset('assets/images/coins.png')),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const Text(
              'Need more money? add to your \nwallet now',
              style: TextStyle(
                fontSize: 20,
                color: secondary,
                fontFamily: 'IrishGrover',
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            AddForm(_submitForm, _loadingSubmit)
          ],
        ),
      ),
    );
  }
}
