import 'package:eventique_admin_dashboard/providers/categories_event_type.dart';
import 'package:eventique_admin_dashboard/providers/customer_provider.dart';
import 'package:eventique_admin_dashboard/providers/packages.dart';
import 'package:eventique_admin_dashboard/screens/package_details.dart';

import '/providers/admin_provider.dart';
import '/providers/business_overview_provider.dart';
import '/providers/theme_provider.dart';
import '/screens/forget_password_screen.dart';
import '/widgets/verification_form.dart';
import 'package:provider/provider.dart';

import '/screens/verification_screen.dart';

import '/screens/enter_email_screen.dart';
import '/screens/main_screen.dart';
import '/screens/login_screen.dart';
import 'package:flutter/material.dart';

String host = 'http://192.168.1.104:8000';
Future<void> main() async {
  final authProvider = AdminProvider();
  await authProvider.loadUserData();

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: MyApp(authProvider: authProvider),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AdminProvider authProvider;

  MyApp({super.key, AdminProvider? authProvider})
      : authProvider = authProvider ?? AdminProvider();
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final token = authProvider.token;
    final id = authProvider.adminId;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        ChangeNotifierProxyProvider<AdminProvider, BusinessOverviewPro>(
          create: (_) => BusinessOverviewPro(token),
          update: (context, auth, previous) => BusinessOverviewPro(auth.token),
        ),
        ChangeNotifierProxyProvider<AdminProvider, Packages>(
          create: (_) => Packages(token),
          update: (context, auth, previous) => Packages(auth.token),
        ),
        ChangeNotifierProxyProvider<AdminProvider, CategoriesAndTypes>(
          create: (_) => CategoriesAndTypes(token),
          update: (context, auth, previous) => CategoriesAndTypes(auth.token),
        ),
        ChangeNotifierProxyProvider<AdminProvider, CustomerProvider>(
          create: (_) => CustomerProvider(token),
          update: (context, auth, previous) => CustomerProvider(auth.token),
        ),
      ],
      child: Consumer<AdminProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Admin',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: authProvider.isAuthenticated
              ? MainScreen(
                  token: token,
                )
              : LoginScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            EnterEmailScreen.routeName: (ctx) => EnterEmailScreen(),
            VerificationScreen.routeName: (ctx) => VerificationScreen(),
            VerificationForm.routeName: (ctx) => VerificationForm(),
            ForgetPasswordScreen.routeName: (ctx) => ForgetPasswordScreen(),
            MainScreen.routeName: (ctx) => MainScreen(
                  token: token,
                )
          },
        ),
      ),
    );
  }
}
