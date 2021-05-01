import 'dart:convert';

import 'package:armada/ad_manager.dart';
import 'package:armada/ad_state.dart';
import 'package:armada/constants/theme.dart';
import 'package:armada/models/New.dart';
import 'package:armada/widgets/newCard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = [
    'business',
    'entertainment',
    'technology',
    'science',
    'health',
    'sports'
  ];

  String fetchcategorie = 'business';

  Future<List<dynamic>> fetchArticles(String categorie) async {
    var result = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=' +
            categorie +
            '&apiKey=e783fa865d9e48ba9faf1644c4be257b'));

    // print("articles ==>" + json.decode(result.body)['articles'][1]['author']);

    return json.decode(result.body)['articles'];
  }

  BannerAd banner;
  InterstitialAd interstitial;

// ignore: todo
// TODO: Add _kAdIndex
  static final _kAdIndex = 4;

// ignore: todo
  // TODO: Add a BannerAd instance
  BannerAd _ad;

// ignore: todo
  // TODO: Add _isAdLoaded
  bool _isAdLoaded = false;

  //  Add _getDestinationItemIndex()
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  void initState() {
    super.initState();
    // itemList = List.from(fetchArticles('categorie'));
    //
    // ignore: todo
    // TODO: Create a BannerAd instance
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdTest,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    )..load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AddState>(context);
    adState.initialization.then((status) => {
          setState(() {
            // banner = new BannerAd(
            //     adUnitId: adState.bannerAdUnitId,
            //     size: AdSize.banner,
            //     request: AdRequest(),
            //     listener: adState.adListener);

            // banner.load();

            // interstitial = InterstitialAd(
            //     adUnitId: adState.interstitialAdUnitId,
            //     listener: adState.adListener,
            //     request: AdRequest())
            //   ..load();
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    _ad.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: honey,
      body: SingleChildScrollView(
        child: Container(
          // margin: E,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // if (banner == null)
              //   SizedBox(
              //     height: 50,
              //   )
              // else
              //   Container(
              //     height: 50,
              //     child: AdWidget(
              //       ad: banner,
              //     ),
              //   ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 15),
                height: height * 0.08,
                width: width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, item) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            fetchcategorie = categories[item];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: fetchcategorie == categories[item]
                                ? honey
                                : mediumgrey,
                            borderRadius: BorderRadius.circular(33),
                          ),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              categories[item],
                              style: TextStyle(fontSize: 18, color: white),
                            ),
                          )),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder<List<dynamic>>(
                  future: fetchArticles(fetchcategorie),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // print("snapshot data ==> " + snapshot.data);
                      return Container(
                        height: height,
                        width: width,
                        child: ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount:
                                snapshot.data.length + (_isAdLoaded ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (_isAdLoaded && index == _kAdIndex) {
                                return Container(
                                  child: AdWidget(ad: _ad),
                                  width: _ad.size.width.toDouble(),
                                  height: 72.0,
                                  alignment: Alignment.center,
                                );
                              } else {
                                final data = snapshot
                                    .data[_getDestinationItemIndex(index)];
                                New card = new New(
                                  data['source']['name'],
                                  data["author"],
                                  data["title"],
                                  data["description"],
                                  data["url"],
                                  data["urlToImage"],
                                );
                                return NewCard(
                                  news: card,
                                );
                                //  final item = snap[_getDestinationItemIndex(index)];
                              }
                            }),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
