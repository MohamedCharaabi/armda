import 'dart:convert';

import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/utils.dart';
import 'package:armada/models/IndexPodcast.dart';
import 'package:armada/models/PLayerProvider.dart';
import 'package:armada/models/Podcast.dart';
import 'package:armada/models/podcast.dart';
import 'package:armada/widgets/podcast_details.dart';
import 'package:armada/widgets/podcastSearch.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:toggle_bar/toggle_bar.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  Future<List<IndexPodcast>> trendingPodCastIndex;
  TextEditingController _searchController = new TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();

  IconData playIcon = Icons.play_arrow;
  String playerurl;

  @override
  void initState() {
    super.initState();
    trendingPodCastIndex = trending();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   playerurl =
    //       Provider.of<PlayerProvider>(context, listen: true).player.playerUrl;
    //   playerurl == '' ? playIcon = Icons.play_arrow : playIcon = Icons.pause;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: red,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: height,
                width: width,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: width,
                      color: white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.75,
                            child: TextFormField(
                              controller: _searchController,
                              style: TextStyle(color: black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                focusColor: white,
                                hintText: 'Enter Search',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: red,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PodcastSearchIndex(
                                            searchTerms: _searchController.text,
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Top Today',
                      style: TextStyle(color: white, fontSize: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    FutureBuilder<List<IndexPodcast>>(
                        future: trendingPodCastIndex,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          return Container(
                            height: height * 0.39,
                            width: width,
                            color: Colors.transparent,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 12,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PodcastDetails(
                                                    podcast:
                                                        snapshot.data[index])),
                                      );
                                    },
                                    child: Container(
                                      // height: 55,
                                      width: width * 0.5,
                                      margin: EdgeInsets.only(right: 15),
                                      color: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                      .data[index].image
                                                      .startsWith('https')
                                                  ? snapshot.data[index].image
                                                  : snapshot.data[index].image
                                                      .replaceFirst(
                                                          RegExp('http'),
                                                          'https'),
                                              memCacheHeight: 600,
                                              memCacheWidth: 600,
                                              placeholder: (context, url) =>
                                                  new CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) {
                                                return Image.asset(
                                                    'assets/images/podcast-icon.png');
                                              },
                                            ),
                                            // fit: BoxFit.contain),
                                          ),
                                          Text(
                                            snapshot.data[index].title != null
                                                ? snapshot.data[index].title
                                                : '******',
                                            style: TextStyle(
                                              color: white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                    // SizedBox(
                    //   height: 1,
                    // ),
                    ToggleBar(
                      labels: [
                        'Science',
                        'Health & Fitness',
                        'History',
                        'Business',
                        'Education',
                        'Arts'
                      ],
                      backgroundColor: violet,
                    ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//   Future<List<PodCastIndex>> bestPodcasts() async {
//     Map<String, String> headers = {
//       "X-ListenAPI-Key": '80a9b08ab52143c1bec5c31f5b159b6b'
//     };

//     var response = await http.get(
//         Uri.parse(
//             'https://listen-api.listennotes.com/api/v2/best_podcasts?genre_id=93&page=2&region=us&safe_mode=0'),
//         headers: headers);

//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       var results = jsonDecode(response.body)['podcasts'];
//       List<PodCastIndex> podcasts = [];

//       for (var item in results) {
//         // print('podcat == $item');

//         podcasts.add(PodCastIndex.fromJson(item));
//       }

//       return podcasts;

//       // return PodCastIndex.fromJson(jsonDecode(response.body)['results']);
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//   }

//   Future getPodcast(String id) async {
//     Map<String, String> headers = {
//       "X-ListenAPI-Key": '80a9b08ab52143c1bec5c31f5b159b6b'
//     };

//     var response = await http.get(
//         Uri.parse(
//             'https://listen-api.listennotes.com/api/v2/podcasts/$id?next_episode_pub_date=1479154463000&sort=recent_first'),
//         headers: headers);

//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       var results = jsonDecode(response.body)['podcasts'];
//       List<PodCastIndex> podcasts = [];

//       for (var item in results) {
//         // print('podcat == $item');

//         podcasts.add(PodCastIndex.fromJson(item));
//       }

//       return podcasts;

//       // return PodCastIndex.fromJson(jsonDecode(response.body)['results']);
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//   }

//   Future<PodCastIndex> fetchPodCastIndex() async {
//     var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
//     String newUnixTime = unixTime.toString();
//     // Change to your API key...
//     var apiKey = "5BBTYPUPE6RYFK9XMW62";
//     // Change to your API secret...
//     var apiSecret = "qCducM5HQndAjqw7T\$\$K56Mdj4\$\SxkQp4Kaaepn6";

//     // print(apiSecret);
//     var firstChunk = utf8.encode(apiKey);
//     var secondChunk = utf8.encode(apiSecret);
//     var thirdChunk = utf8.encode(newUnixTime);

//     var output = new AccumulatorSink<Digest>();
//     var input = sha1.startChunkedConversion(output);
//     input.add(firstChunk);
//     input.add(secondChunk);
//     input.add(thirdChunk);
//     input.close();
//     var digest = output.events.single;

//     Map<String, String> headers = {
//       "X-Auth-Date": newUnixTime,
//       "X-Auth-Key": apiKey,
//       "Authorization": digest.toString(),
//       "User-Agent": "SomethingAwesome/1.0.1"
//     };

//     final response = await http.get(
//         Uri.parse(
//             'https://api.podcastindex.org/api/1.0/search/byterm?q=bastiat'),
//         headers: headers);

//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       return PodCastIndex.fromJson(json.decode(response.body));
//     } else { 
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//   }
//
