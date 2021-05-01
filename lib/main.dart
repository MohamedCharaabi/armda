// import 'dart:js';

import 'package:armada/helpers/notification.dart';
import 'package:armada/models/AdsProvider.dart';
import 'package:armada/models/PLayerProvider.dart';
import 'package:armada/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'ad_state.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  //ensure that all widgets are loaded
  WidgetsFlutterBinding.ensureInitialized();

  //Local notification config
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //   requestSoundPermission: true,
  //   requestBadgePermission: true,
  //   requestAlertPermission: true,
  //   onDidReceiveLocalNotification:
  //       (int id, String title, String body, String payload) async {},
  // );

  // final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String payload) async {
  //   if (payload != null) {
  //     debugPrint('Notification payload : $payload');
  //   }
  // });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<NotificationService>(
        create: (context) => NotificationService(),
        // builder: (context, child) => MyApp(),
      ),
      ChangeNotifierProvider<PlayerProvider>(
        create: (context) => PlayerProvider(),
      ),
      ChangeNotifierProvider<AdsProvider>(
        create: (context) => AdsProvider(),
      ),
    ],
    child: MyApp(),
  ));

  //   ChangeNotifierProvider(
  //     create: (context) => PlayerProvider(),
  //     child: Provider.value(
  //       value: adState,builder: (context, child) => MyApp(),),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
