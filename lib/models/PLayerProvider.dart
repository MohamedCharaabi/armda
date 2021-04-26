import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class PlayerProvider with ChangeNotifier {
  AudioPlayer audioPlayer = new AudioPlayer();
  Player player = Player(
      height: 0, image: '', id: 0, title: '', playerUrl: '', playbtn: false);

  void changePlayer(Player p) {
    player = p;
    notifyListeners();
  }

  void changePlayerStateBtn(bool p) {
    player.changeplayerBtn(p);
    notifyListeners();
  }

  void closePlayer() {
    audioPlayer.stop();
    notifyListeners();
  }
}

class Player {
  double height;
  int id;
  String title;
  String image;
  String playerUrl;
  bool playbtn;

  Player(
      {this.height,
      this.id,
      this.title,
      this.image,
      this.playerUrl,
      this.playbtn});

  Map<String, dynamic> get player {
    return {
      "height": height,
      'id': id,
      "title": title,
      "image": image,
      "playerUrl": playerUrl,
      "playbtn": playbtn
    };
  }

  // void set changeplayerBtn(bool btn) {
  // }

  void changeplayerBtn(bool p) {
    playbtn = p;
  }
}
