class PodCastIndex {
  final String id;
  final String title;
  final String description;

  final String image;

  PodCastIndex({
    this.id,
    this.title,
    this.description,
    this.image,
  });

  factory PodCastIndex.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return PodCastIndex(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }
}
