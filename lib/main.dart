import 'package:armada/models/AdsProvider.dart';
import 'package:armada/models/PLayerProvider.dart';
import 'package:armada/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'ad_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AddState(initFuture);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AddState>.value(
        value: adState,
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
