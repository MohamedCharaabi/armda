import 'dart:convert';
import 'package:armada/models/IndexEpisode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:armada/models/IndexPodcast.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<List<IndexEpisode>> fetchEpisodes(String feed) async {
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
      Uri.parse(
          'https://api.podcastindex.org/api/1.0/episodes/byfeedurl?url=$feed'),
      headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<IndexEpisode> episodes = [];

    var result = json.decode(response.body)['items'];

    for (var epi in result) {
      episodes.add(IndexEpisode.fromJson(epi));
    }
    return episodes;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load episodes');
  }
}

Future<List<IndexPodcast>> searchPodcasts(String terms) async {
  terms.replaceAll(new RegExp(r"\s+"), ""); //removing spaces

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
      Uri.parse('https://api.podcastindex.org/api/1.0/search/byterm?q=$terms'),
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
    throw Exception('Failed to load podcasts');
  }
}

Future<void> launchInApp(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: false,
      // headers: <String, String>{'header_key': 'header_value'}
    );
  } else {
    throw 'could not lunch $url';
  }
}
