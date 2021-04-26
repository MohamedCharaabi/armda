import 'dart:async';
import 'dart:convert';

import 'package:armada/constants/theme.dart';
import 'package:armada/models/IndexPodcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

Future<PodCastIndex> fetchPodCastIndex() async {
  var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  String newUnixTime = unixTime.toString();
  // Change to your API key...
  var apiKey = "BN5DX5BEXNA6BDHDBE6J";
  // Change to your API secret...
  var apiSecret = "FTDNV4ZKUHb#VX8D2aaBD6r7bMG48nZs#\$eBsEBb";
  var firstChunk = utf8.encode(apiKey);
  var secondChunk = utf8.encode(apiSecret);
  var thirdChunk = utf8.encode(newUnixTime);

  var output = new AccumulatorSink<Digest>();
  var input = sha1.startChunkedConversion(output);
  input.add(firstChunk);
  input.add(secondChunk);
  input.add(thirdChunk);
  input.close();
  var digest = output.events.single;

  Map<String, String> headers = {
    "X-Auth-Date": newUnixTime,
    "X-Auth-Key": apiKey,
    "Authorization": digest.toString(),
    "User-Agent": "SomethingAwesome/1.0.1"
  };

  final response = await http.get(
      Uri.parse('https://api.podcastindex.org/api/1.0/search/byterm?q=bastiat'),
      headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PodCastIndex.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class PodCastIndex {
  final String content;

  PodCastIndex({this.content});

  factory PodCastIndex.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return PodCastIndex(content: json.toString());
  }
}

Future<List<IndexPodcast>> trending() async {
  var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  String newUnixTime = unixTime.toString();
  // Change to your API key...
  var apiKey = "BN5DX5BEXNA6BDHDBE6J";
  // Change to your API secret...
  var apiSecret = "FTDNV4ZKUHb#VX8D2aaBD6r7bMG48nZs#\$eBsEBb";
  var firstChunk = utf8.encode(apiKey);
  var secondChunk = utf8.encode(apiSecret);
  var thirdChunk = utf8.encode(newUnixTime);

  var output = new AccumulatorSink<Digest>();
  var input = sha1.startChunkedConversion(output);
  input.add(firstChunk);
  input.add(secondChunk);
  input.add(thirdChunk);
  input.close();
  var digest = output.events.single;

  Map<String, String> headers = {
    "X-Auth-Date": newUnixTime,
    "X-Auth-Key": apiKey,
    "Authorization": digest.toString(),
    "User-Agent": "SomethingAwesome/1.0.1"
  };

  final response = await http.get(
      Uri.parse('https://api.podcastindex.org/api/1.0/podcasts/trending'),
      headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<IndexPodcast> podcasts = [];

    var result = json.decode(response.body)['feeds'];

    for (var pod in result) {
      podcasts.add(IndexPodcast.fromJson(pod));
    }
    return podcasts;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MyAppT extends StatefulWidget {
  MyAppT({Key key}) : super(key: key);

  @override
  _MyAppTState createState() => _MyAppTState();
}

class _MyAppTState extends State<MyAppT> {
  Future<PodCastIndex> futurePodCastIndex;
  Future<List<IndexPodcast>> fetchTrending;

  @override
  void initState() {
    super.initState();
    futurePodCastIndex = fetchPodCastIndex();
    fetchTrending = trending();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: red,
      appBar: AppBar(
        title: Text('Fetch Podcast Listing JSON'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<IndexPodcast>>(
          future: trending(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('data::: ${snapshot.data}');
              // return Text(snapshot.data.content);
              //
              return Container(
                height: height * 0.39,
                width: width,
                color: Colors.transparent,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      // debugPrint('hi');

                      if (snapshot.data[index].image
                          .startsWith('https://intotomorrow.com/')) {
                        return SizedBox(
                          width: 0,
                        );
                      }
                      return InkWell(
                        onTap: () {
                          // Player p = new Player(
                          //     height: height * 0.13,
                          //     title: 'nice JOB',
                          //     image: snapshot.data[index].image,
                          //     playerUrl:
                          //         'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3');
                          // context
                          //     .read<PlayerProvider>()
                          //     .changePlayer(p);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           PodcastDetails(
                          //               podcast:
                          //                   snapshot.data[index])),
                          // );
                        },
                        child: Container(
                          // height: 55,
                          width: width * 0.5,
                          margin: EdgeInsets.only(right: 15),
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data[index].image
                                          .startsWith('https')
                                      ? snapshot.data[index].image
                                      : snapshot.data[index].image.replaceFirst(
                                          RegExp('http'), 'https'),
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) {
                                    return Icon(Icons.error);
                                  },
                                ),

                                // Image.network(
                                //     snapshot.data[index].image
                                //             .startsWith('https')
                                //         ? snapshot.data[index].image
                                //         : snapshot.data[index].image
                                //             .replaceFirst(
                                //                 RegExp('http'), 'https'),
                                //     errorBuilder: (BuildContext context,
                                //         Object exception,
                                //         StackTrace stackTrace) {
                                //   return Text('Error image...');
                                // }, fit: BoxFit.contain),
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
              //
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
