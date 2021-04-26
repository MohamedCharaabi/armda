class PodCast {
  final String content;

  PodCast({this.content});

  factory PodCast.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return PodCast(content: json.toString());
  }
}
