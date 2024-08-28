import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:pemob_uas/global_providers.dart';
import 'package:pemob_uas/myremote_config_service.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:pemob_uas/ui/parent_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _showNotification(notifID, title, body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'com.kspay.app.notif', // Replace with a unique identifier
    'KSPay', // Replace with a user-friendly name
    channelDescription:
        'Your Channel Description', // Replace with a description
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    enableVibration: true,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    notifID, // Notification ID
    title, // Notification Title
    body, // Notification Body
    platformChannelSpecifics,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  try {
    print("Handling a background message: ${message.messageId}");
    print('Got a message whilst in the background!');
    print('Message data: ${message.data}');

    SharedPreferences pref = await SharedPreferences.getInstance();
    var isLogin = pref.getBool(SessionManager.IS_LOGIN) ?? false;
    // var email = pref.getString(SessionManager.EMAIL) ?? '-';

    _showNotification(
        0, message.notification!.title, message.notification!.body);
  } catch (e) {
    print(e);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await RemoteConfigService().initialize();
  var providers = await GlobalProviders.register();
  // var isLogin = await SessionManager.checkIfLoggedin();

  final pref = await SharedPreferences.getInstance();

  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    pref.setString(SessionManager.FIREBASE_ID, fcmToken ?? '-');
    print("FID:$fcmToken");

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // pref.setString(Cons.firebaseID, fcmToken);
      print('Storing fID in device [$fcmToken]');
    }).onError((err) {
      // Error getting token.
      print('Error storing fID in device, $err');
    });
  } catch (e, s) {
    Logger().e(e.toString(), stackTrace: s);
  }

  // NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    // print('Message data: ${message.data}');

    if (message.notification != null) {
      _showNotification(
          0, message.notification!.title, message.notification!.body);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.providers});
  final List<dynamic> providers;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...providers],
      child: ResponsiveSizer(builder: (context, orientation, type) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            useMaterial3: false,
          ),
          home: const ParentScreen(),
          builder: EasyLoading.init(),
        );
      }),
    );
  }
}
