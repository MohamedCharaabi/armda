import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/utils.dart';
import 'package:armada/models/IndexPodcast.dart';
import 'package:armada/models/PLayerProvider.dart';
import 'package:armada/widgets/podcast_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PodcastSearchIndex extends StatefulWidget {
  final String searchTerms;
  PodcastSearchIndex({@required this.searchTerms});

  @override
  _PodcastSearchIndexState createState() => _PodcastSearchIndexState();
}

class _PodcastSearchIndexState extends State<PodcastSearchIndex> {
  Future<List<IndexPodcast>> searchPodCastIndex;
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // _searchController.text = widget.searchTerms;
    searchPodCastIndex = searchPodcasts(widget.searchTerms.trim());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: red,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: height,
          // margin: EdgeInsets.symmetric(horizontal: 8.0),
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: width,
                      color: white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: width * 0.75,
                            child: TextFormField(
                              controller: _searchController,
                              style: TextStyle(color: black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                focusColor: white,
                                hintText: '${widget.searchTerms}',
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
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => PodcastSearchIndex(
                              //               searchTerms: _searchController.text,
                              //             )));
                              setState(() {
                                searchPodCastIndex = searchPodcasts(
                                    _searchController.text.trim());
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<List<IndexPodcast>>(
                      future: searchPodCastIndex,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print("${snapshot.data}");
                          return Container(
                            height: height * 0.8,
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemCount: snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (MediaQuery.of(context).orientation ==
                                            Orientation.portrait)
                                        ? 2
                                        : 3,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PodcastDetails(
                                              podcast: snapshot.data[index])),
                                    );
                                  },
                                  child: Container(
                                    height: height * 0.27,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: EdgeInsets.only(bottom: 15),
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
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
                                              // fit: BoxFit.fill,
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) {
                                                print(
                                                    'errror image : ${error.toString()}');
                                                print('url ::: $url');
                                                return Image.asset(
                                                    'assets/images/podcast-icon.png');
                                              },
                                            ),
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index].title != null
                                              ? snapshot.data[index].title
                                              : '******',
                                          style: TextStyle(
                                            color: white,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error");
                        }
                        return Center(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              child: Consumer<PlayerProvider>(
                builder: (context, provider, child) {
                  return Container(
                    height: provider.player.height,
                    width: width,
                    // margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: violet,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            Consumer<PlayerProvider>(
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
                                        print('provider player === null');
                                      }
                                    });
                              },
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: white,
                                ),
                                onPressed: () async {
                                  int result =
                                      await provider.audioPlayer.stop();
                                  print('$result');

                                  Player p = new Player(
                                      height: 0,
                                      image: '',
                                      title: '',
                                      playerUrl: '',
                                      playbtn: false);
                                  context
                                      .read<PlayerProvider>()
                                      .changePlayer(p);
                                })
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
