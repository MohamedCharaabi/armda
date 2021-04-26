import 'package:armada/ad_manager.dart';
import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/utils.dart';
import 'package:armada/models/AdsProvider.dart';
import 'package:armada/models/New.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class NewCard extends StatefulWidget {
  final New news;
  final String title;
  final String source;
  final String desc;
  final String url;
  final String imgurl;

  NewCard(
      {@required this.news,
      this.title,
      this.source,
      this.desc,
      this.url,
      this.imgurl});
  @override
  _NewCardState createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  InterstitialAd _interstitialAd;

  // TODO: Add _isAdLoaded
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _interstitialAd = InterstitialAd(
      adUnitId: AdHelper.interstitialAdUnitIdTest,
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
    );

    // TODO: Load an ad
    _interstitialAd.load();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // print("titke  ${widget.news.title != null ? widget.news.title : ''}");

    return Consumer<AdsProvider>(builder: (context, provider, child) {
      return InkWell(
        onTap: () {
          // print('card click ${widget.news.link}');
          // launchInApp(widget.news.link);
          int count = context.read<AdsProvider>().count;
          if (count < 5) {
            print('count === $count');

            context.read<AdsProvider>().addCount();

            return Fluttertoast.showToast(
                msg: 'count === $count', toastLength: Toast.LENGTH_SHORT);
          } else {
            print('count is more than 5 => $count');
            if (_isAdLoaded) {
              _interstitialAd.show();
            }
          }
        },
        child: Container(
          height: height * 0.55,
          width: width,
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.only(
            bottom: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: height * 0.3,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  // image: DecorationImage(
                  //   image:
                  //    NetworkImage(
                  //     widget.news.imageLink != null
                  //         ? widget.news.imageLink
                  //         : 'https://wallpaperaccess.com/thumb/1588284.jpg',
                  //     // memcacheWidth: 600,
                  //     // cacheHeight: 600,
                  //     // width: width * 0.25,
                  //     // height: height * 0.14,
                  //     // fit: BoxFit.cover
                  //   ),
                  //   fit: BoxFit.fill,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.news.imageLink,
                    memCacheHeight: 600,
                    memCacheWidth: 600,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                        child: Image.network(
                      'https://assets.materialup.com/uploads/fa8430a1-4dea-49d9-a4a3-e5c6bf0b2afb/preview.gif',
                      fit: BoxFit.fill,
                    )),
                    errorWidget: (context, url, error) {
                      print('errror image : ${error.toString()}');
                      print('url ::: $url');
                      return Image.asset('assets/images/podcast-icon.png');
                    },
                  ),
                ),
              ),
              SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.news.title != null
                          ? '${widget.news.title.substring(0, 30)}..'
                          : '',
                      style: TextStyle(
                          color: black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      (widget.news.description != null &&
                              widget.news.description.length > 60)
                          ? '${widget.news.description.substring(0, 60)}..' //23
                          : widget.news.description ?? '',
                      style: TextStyle(
                        color: black,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
