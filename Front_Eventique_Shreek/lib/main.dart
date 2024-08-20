import 'package:eventique_company_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';
import '/providers/theme_provider.dart';
import '/providers/auth_vendor.dart';
import '/providers/event_provider.dart';
import '/providers/services_provider.dart';
import '/providers/users_provider.dart';
import '/providers/orders.dart';
import '/providers/reviews.dart';
import '/providers/statics_provider.dart';
import '/providers/services_list.dart';
import '/screens/navigation_bar_page.dart';
import '/screens/email_rest_screen.dart';
import '/screens/password_rest_screen.dart';
import '/screens/vendor_profile_screen.dart';
import '/screens/verification_screen.dart';
import '/screens/chat_screen.dart';
import '/screens/enter_email_screen.dart';
import '/screens/forget_password_screen.dart';
import '/screens/login_screen.dart';
import '/screens/user_profile_screen.dart';
import '/screens/sign_up_screens/sign_up_screen1.dart';
import '/screens/sign_up_screens/sign_up_screen2.dart';
import '/screens/sign_up_screens/sign_up_screen3.dart';
import '/screens/sign_up_screens/sign_up_screen4.dart';

const String host = 'http://192.168.1.104:8000';

// Create a global key for the navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'eventique_company_app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final authProvider = AuthVendor();
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
    await sendTokenToBackend(token, authProvider.userId);
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
      // Handle the notification, e.g., navigate to a specific screen:
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

Future<void> sendTokenToBackend(String token, int id) async {
  final url = '$host/api/companies/updateFCM';
  print(id);
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: '{"fcm_token": "$token","company_id":$id}',
    );

    if (response.statusCode == 200) {
      print('Token sent to backend successfully');
    } else {
      print('Failed to send token to backend. Status code: ${response.body}');
    }
  } catch (e) {
    print('Error sending token to backend: $e');
  }
}

class MyApp extends StatelessWidget {
  final AuthVendor authProvider;

  MyApp({super.key, AuthVendor? authProvider})
      : authProvider = authProvider ?? AuthVendor();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        ChangeNotifierProxyProvider<AuthVendor, ServiceProvider>(
          create: (_) =>
              ServiceProvider(authProvider.token, authProvider.userId),
          update: (context, auth, previous) =>
              ServiceProvider(auth.token, auth.userId),
          // value: ServiceProvider(authProvider.token, authProvider.userId),
        ),
        ChangeNotifierProvider.value(
          value: EventProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UsersProvider(authProvider.token),
        ),
        ChangeNotifierProxyProvider<AuthVendor, Orders>(
          create: (_) => Orders(authProvider.token, authProvider.userId),
          update: (context, auth, previous) => Orders(auth.token, auth.userId),
        ),
        ChangeNotifierProxyProvider<AuthVendor, AllServices>(
          create: (_) => AllServices(authProvider.userId, authProvider.token),
          update: (context, auth, previous) =>
              AllServices(auth.userId, auth.token),
        ),
        ChangeNotifierProxyProvider<AuthVendor, Reviews>(
          create: (_) => Reviews(authProvider.token),
          update: (context, auth, previous) => Reviews(auth.token),
        ),
        ChangeNotifierProxyProvider<AuthVendor, StatisticsProvider>(
          create: (_) => StatisticsProvider(
            authProvider.token,
            authProvider.userId,
          ),
          update: (context, auth, previous) => StatisticsProvider(
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider.value(
          value: ThemeProvider(),
        ),
      ],
      child: Consumer<AuthVendor>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'EvenTique',
          themeMode: themeProvider.getThemeMode(),
          home: auth.isAuthenticated ? NavigationBarPage() : LoginScreen(),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          routes: {
            SignUpScreen1.routeName: (ctx) => SignUpScreen1(),
            SignUpScreen2.routeName: (ctx) => SignUpScreen2(),
            SignUpScreen3.routeName: (ctx) => SignUpScreen3(),
            SignUpScreen4.routeName: (ctx) => SignUpScreen4(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            EnterEmailScreen.routeName: (ctx) => EnterEmailScreen(),
            NewPasswordScreen.routeName: (ctx) => NewPasswordScreen(),
            EmailRestScreen.routeName: (ctx) => EmailRestScreen(),
            PasswordRestScreen.routeName: (ctx) => PasswordRestScreen(),
            VendorProfileScreen.routeName: (ctx) => VendorProfileScreen(),
            VerificationScreen.routeName: (ctx) => VerificationScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
            UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
            NavigationBarPage.routeName: (ctx) => NavigationBarPage(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
          },
        ),
      ),
    );
  }
}
