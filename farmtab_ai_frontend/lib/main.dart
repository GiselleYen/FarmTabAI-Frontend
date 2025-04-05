import 'package:farmtab_ai_frontend/login_register/signin_screen.dart';
import 'package:farmtab_ai_frontend/nav%20tab/home_tab_view.dart';
import 'package:farmtab_ai_frontend/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'login_register/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await dotenv.load(fileName: ".env");

  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await initLocalNotifications();

    // ✅ Keep this: Background handler setup
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  runApp(MyApp());
}

// 🔧 Local notifications setup
Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// 🔧 Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Background message: ${message.notification?.title}');
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool _hasInitializedMessaging = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isLoggedIn) {
          setupFirebaseMessaging();
        }
      });
    }
  }

  void setupFirebaseMessaging() async {
    if (_hasInitializedMessaging) return; // ✅ Avoid duplicate setup
    _hasInitializedMessaging = true;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    if (token != null) {
      print("✅ FCM Token: $token");
      sendTokenToBackend(token);
    }

    // ✅ Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🟢 Foreground message: ${message.notification?.title}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Sensor Alerts',
              channelDescription: 'Farm sensor alert notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // Background & tap handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 App opened via notification: ${message.data}');
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('🟡 App launched from notification: ${message.data}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          authProvider.setOnLoginSuccessCallback(() {
            setupFirebaseMessaging();
          });
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'FarmTab AI',
            home: authProvider.isLoading
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                : authProvider.isLoggedIn
                ? const HomeTabView()
                : const WelcomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
