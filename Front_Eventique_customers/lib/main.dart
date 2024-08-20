import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';
import '/providers/accepted_services.dart';
import '/providers/saved.dart';
import '/providers/share_event_provider.dart';
import '/providers/vendors_provider.dart';
import '/providers/wallet_provider.dart';
import '/screens/chat_vendors_list.dart';
import '/providers/home_provider.dart';
import '/providers/carts.dart';
import '/providers/events.dart';
import '/providers/orders.dart';
import '/providers/reviews.dart';
import '/providers/services_list.dart';
import '/screens/navigation_bar_page.dart';
import '/screens/one_package_details.dart';
import '/screens/one_you&us.dart';
import '/screens/share_event_screen.dart';
import '/screens/shared_events_for_one_user_screen.dart';
import '/screens/wallet_screen.dart';
import '/providers/theme_provider.dart';
import '/providers/auth_provider.dart';
import '/screens/auth_screen.dart';
import '/screens/enter_email_screen.dart';
import '/screens/home_screen.dart';
import '/screens/new_password_screen.dart';
import '/screens/verification_screen.dart';
import 'screens/chat_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/settings_screen.dart';
import '/screens/email_rest_screen.dart';
import '/screens/password_rest_screen.dart';
import '/screens/vendor_profile_screen.dart';

const String host = 'http://192.168.1.104:8000';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final authProvider = Auth();
  await authProvider.loadUserData();

  // Initialize Firebase Messaging and configure local notifications
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permissions for iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  // Get the FCM token
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Send FCM token to the backend
  if (token != null) {
    await sendTokenToBackend(token, authProvider.token);
  }

  // Initialize Flutter Local Notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Handle messages when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id', // You need to define this channel in AndroidManifest.xml
            'your_channel_name',
            channelDescription: 'your_channel_description',
            icon: android.smallIcon,
          ),
        ),
      );
    }
  });

  // Handle notification when the app is opened from a terminated state
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('Notification clicked with message: ${message.data}');
      // Handle the notification
      // For example, navigate to a specific screen:
      // navigatorKey.currentState?.pushNamed('/yourRoute');
    }
  });

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: MyApp(authProvider: authProvider),
    ),
  );
}

Future<void> sendTokenToBackend(String token, String? userToken) async {
  final url = '$host/api/updateFCM';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: '{"fcm_token": "$token"}',
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('Token sent to backend successfully');
    } else {
      print(
          'Failed to send token to backend. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending token to backend: $e');
  }
}

class MyApp extends StatelessWidget {
  final Auth authProvider;

  MyApp({super.key, Auth? authProvider})
      : authProvider = authProvider ?? Auth();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final token = authProvider.token;
    final id = authProvider.userId;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        ChangeNotifierProvider.value(
          value: HomeProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, VendorsProvider>(
          create: (_) => VendorsProvider(token),
          update: (context, auth, previous) => VendorsProvider(auth.token),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AllServices(),
        ),
        ChangeNotifierProxyProvider<Auth, Reviews>(
          create: (_) => Reviews(token),
          update: (context, auth, previous) => Reviews(auth.token),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Carts(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(token, id),
          update: (context, auth, previous) => Orders(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, Events>(
          create: (_) => Events(token, id),
          update: (context, auth, previous) => Events(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, Saved>(
          create: (_) => Saved(token),
          update: (context, auth, previous) => Saved(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, AcceptedServicesPro>(
          create: (_) => AcceptedServicesPro(token),
          update: (context, auth, previous) => AcceptedServicesPro(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, WalletProvider>(
          create: (_) => WalletProvider(token, id),
          update: (context, auth, previous) =>
              WalletProvider(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, ShareEventProvider>(
          create: (_) => ShareEventProvider(token),
          update: (context, auth, previous) => ShareEventProvider(auth.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'EvenTique',
          themeMode: themeProvider.getThemeMode(),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey, // Add the navigator key
          home: auth.isAuthenticated ? NavigationBarPage() : AuthScreen(),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            VerificationScreen.routeName: (ctx) => VerificationScreen(),
            EnterEmailScreen.routeName: (ctx) => EnterEmailScreen(),
            NewPasswordScreen.routeName: (ctx) => NewPasswordScreen(),
            NavigationBarPage.routeName: (context) => NavigationBarPage(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            ChatListScreen.routeName: (ctx) => ChatListScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            VendorProfileScreen.routeName: (ctx) => VendorProfileScreen(),
            PasswordRestScreen.routeName: (ctx) => PasswordRestScreen(),
            EmailRestScreen.routeName: (ctx) => EmailRestScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            ShareEventScreen.routeName: (ctx) => ShareEventScreen(),
            OnePackageDetailsPage.routeName: (ctx) => OnePackageDetailsPage(),
            YouAndUsPage.routeName: (ctx) => YouAndUsPage(),
            WalletScreen.routeName: (ctx) => WalletScreen(),
            SharedEventsForOneUserScreen.routeName: (ctx) =>
                SharedEventsForOneUserScreen(),
          },
          theme: ThemeData(
            // useMaterial3: false,
            primaryColor: Color(0xff662465),
            scaffoldBackgroundColor: const Color(0xFFFFFDF0),
            appBarTheme: const AppBarTheme(
              color: Color(0xFFFFFDF0),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Bahnschrift',
                color: Color(0xff662465),
              ),
              bodyMedium: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Bahnschrift',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff662465)),
              bodySmall: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Bahnschrift',
                  color: Color(0xff662465)),
            ),
          ),
        ),
      ),
    );
  }
}
