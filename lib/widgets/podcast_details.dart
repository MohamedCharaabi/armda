import 'dart:convert';

import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/utils.dart';
import 'package:armada/models/IndexEpisode.dart';
import 'package:armada/models/IndexPodcast.dart';
import 'package:armada/models/PLayerProvider.dart';
import 'package:armada/models/podcast.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PodcastDetails extends StatefulWidget {
  IndexPodcast podcast;
  PodcastDetails({@required this.podcast});
  @override
  _PodcastDetailsState createState() => _PodcastDetailsState();
}

class _PodcastDetailsState extends State<PodcastDetails> {
  IconData playIcon = Icons.play_arrow;
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerProvider player;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   player = Provider.of<PlayerProvider>(context, listen: true);
    //   player.player.playerUrl == ''
    //       ? playIcon = Icons.play_arrow
    //       : playIcon = Icons.pause;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: black,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.4,
                width: width,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                  child: Image.network(
                    widget.podcast.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // borderRadius:
                  // BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: SingleChildScrollView(
                  // scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${widget.podcast.title}',
                        style: TextStyle(
                          fontSize: 22,
                          color: white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${widget.podcast.description}',
                        style: TextStyle(
                          fontSize: 15,
                          color: white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Episodes',
                        style: TextStyle(
                          fontSize: 18,
                          color: red,
                        ),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<List<IndexEpisode>>(
                          future: fetchEpisodes(widget.podcast.url),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: red,
                                ),
                              );
                            }
                            List<IndexEpisode> data = snapshot.data;
                            print('data ===> $data');
                            return Container(
                              height: height * 0.5,
                              width: width,
                              color: Colors.transparent,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        width: width,
                                        // height: height * 0.15,
                                        margin: EdgeInsets.only(top: 8),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.transparent,
                                        ),
                                        child: ExpansionTileCard(
                                          baseColor: honey,
                                          leading: Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: honey,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    data[index].image),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          title: Text(data[index].title),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                data[index]
                                                    .description
                                                    .replaceAll('<p>', '')
                                                    .replaceAll('</p>', '')
                                                    .replaceAll('<b>', '')
                                                    .replaceAll('</b>', '')
                                                    .replaceAll('<br>', '')
                                                    .replaceAll('</br>', ''),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                IconButton(
                                                    disabledColor: red,
                                                    icon: Icon(
                                                      Icons.download_sharp,
                                                      size: 30,
                                                    ),
                                                    onPressed: null),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Consumer<PlayerProvider>(
                                                    builder: (context, provider,
                                                        child) {
                                                  return IconButton(
                                                      disabledColor: red,
                                                      icon: Icon(
                                                        provider.player.id ==
                                                                data[index].id
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
                                                        size: 30,
                                                      ),
                                                      onPressed: () async {
                                                        Player p = new Player(
                                                            height:
                                                                height * 0.13,
                                                            image: data[index]
                                                                .image,
                                                            id: data[index].id,
                                                            title: data[index]
                                                                        .title
                                                                        .length >
                                                                    15
                                                                ? data[index]
                                                                    .title
                                                                    .substring(
                                                                        0, 15)
                                                                : data[index]
                                                                    .title,
                                                            playerUrl: data[
                                                                    index]
                                                                .enclosureUrl,
                                                            playbtn: true);

                                                        context
                                                            .read<
                                                                PlayerProvider>()
                                                            .changePlayer(p);

                                                        int result =
                                                            await provider
                                                                .audioPlayer
                                                                .play(provider
                                                                    .player
                                                                    .playerUrl);

                                                        // await provider
                                                        //     .audioPlayer
                                                        //     .setNotification(
                                                        //         title:
                                                        //             'first notif');

                                                        if (result == 1) {
                                                          return Fluttertoast.showToast(
                                                              msg:
                                                                  'playing ${data[index].title}',
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT);
                                                        } else {
                                                          return Fluttertoast.showToast(
                                                              backgroundColor:
                                                                  honey,
                                                              msg:
                                                                  'Error ${data[index].title}',
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT);
                                                        }
                                                      });
                                                })
                                              ],
                                            ),
                                          ],
                                        ));
                                  }),
                            );
                          }),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          child: Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: Consumer<PlayerProvider>(
              builder: (context, provider, child) {
                return Container(
                  height: provider.player.height,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: violet,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          Container(
                            height: 55,
                            width: 55,
                            margin: EdgeInsets.only(left: 5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(provider.player.image),
                                  fit: BoxFit.fill,
                                )),
                          ),
                          SizedBox(width: 5),
                          Text(provider.player.title,
                              style: TextStyle(color: white)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            child: Consumer<PlayerProvider>(
                              builder: (context, provider, child) {
                                return IconButton(
                                    icon: Icon(
                                      provider.player.playbtn == true
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: white,
                                    ),
                                    onPressed: () async {
                                      if (provider.player.playbtn == true) {
                                        int result =
                                            await provider.audioPlayer.pause();

                                        // Player p = new Player(playbtn: true);

                                        context
                                            .read<PlayerProvider>()
                                            .changePlayerStateBtn(false);

                                        print('$result');
                                        print(
                                            ' player ${provider.player.player}');
                                        // setState(() {
                                        //   playIcon = Icons.play_arrow;
                                        // });

                                        // setState(() {
                                        //   playIcon = Icons.pause;
                                        // });
                                      } else if (provider.player.playbtn ==
                                          false) {
                                        int result = await provider.audioPlayer
                                            .play(provider.player.playerUrl);
                                        context
                                            .read<PlayerProvider>()
                                            .changePlayerStateBtn(true);
                                        print('$result');
                                        print(
                                            ' player ${provider.player.player}');
                                      } else {
                                        null;
                                      }
                                    });
                              },
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                color: white,
                              ),
                              onPressed: () async {
                                int result = await provider.audioPlayer.stop();
                                print('$result');

                                Player p = new Player(
                                    height: 0,
                                    image: '',
                                    title: '',
                                    playerUrl: '',
                                    playbtn: false);
                                context.read<PlayerProvider>().changePlayer(p);
                              })
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<List<Episode>> fetchEpisodeData(String id) async {
    Map<String, String> headers = {
      "X-ListenAPI-Key": '80a9b08ab52143c1bec5c31f5b159b6b'
    };

    var response = await http.get(
        Uri.parse(
            'https://listen-api.listennotes.com/api/v2/podcasts/$id?next_episode_pub_date=1479154463000&sort=recent_first'),
        headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var results = jsonDecode(response.body);
      var episodesData = results['episodes'];
      List<Episode> episodes = [];

      for (var item in episodesData) {
        // print('episode == $item');

        episodes.add(Episode.fromJson(item));
      }

      return episodes;

      // return PodCastIndex.fromJson(jsonDecode(response.body)['results']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

// class PodcastData {
//   final String id;
//   final String title;
//   final String description;
//   final String country;
//   final String language;
//   final int totalEpisodes;
//   final List<Episode> episodes;
//   final String image;

//   PodcastData({
//     this.id,
//     this.title,
//     this.description,
//     this.country,
//     this.language,
//     this.totalEpisodes,
//     this.episodes,
//     this.image,
//   });

//   factory PodcastData.fromJson(Map<String, dynamic> json) {
//     print(json.toString());
//     return PodcastData(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       country: json['country'],
//       language: json['language'],
//       totalEpisodes: json['totalEpisodes'],
//       episodes: json['episodes'],
//       image: json['image'],
//     );
//   }
// }

class Episode {
  final String id;
  final String title;
  final String description;
  final String audio;
  final int audioLength;
  final String image;

  Episode({
    this.id,
    this.title,
    this.description,
    this.audio,
    this.audioLength,
    this.image,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return Episode(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      audio: json['audio'],
      audioLength: json['audio_length_sec'],
      image: json['image'],
    );
  }
}
