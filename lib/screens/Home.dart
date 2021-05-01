import 'package:armada/constants/theme.dart';
import 'package:armada/models/PLayerProvider.dart';
// import 'package:armada/screens/Calendar.dart';
import 'package:armada/screens/Settings.dart';
import 'package:armada/screens/HomePage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Podcasts.dart';
import 'Todo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var navigationIndex = 2;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final List<Widget> layouts = [
      HomePage(),
      News(),
      Todo(),
      // CalendarPage()
      Settings(),
    ];

    return Scaffold(
      // backgroundColor: violet,
      body: Stack(children: [
        layouts[navigationIndex],
        Positioned(
          bottom: 5,
          child: Consumer<PlayerProvider>(
            builder: (context, provider, child) {
              return Container(
                height: provider.player.height,
                width: width,
                // margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: honey,
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
                                      print('player == null');
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
                                  playerUrl: '');
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
      ]),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.transparent.withOpacity(0.5),
        backgroundColor: honey,
        buttonBackgroundColor: white,
        height: 50,
        items: <Widget>[
          Icon(Icons.home, size: 25, color: black),
          Icon(Icons.mic, size: 25, color: black),
          Icon(Icons.calendar_today, size: 25, color: black),
          Icon(Icons.settings, size: 25, color: black),
        ],
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.bounceInOut,
        index: navigationIndex,
        onTap: (index) {
          // debugPrint('indecx === > $index');
          setState(() {
            navigationIndex = index;
          });
        },
      ),
    );
  }
}
