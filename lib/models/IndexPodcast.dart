class IndexPodcast {
  final int id;
  final String url;
  final String title;
  final String description;
  final int itunesId;
  final String author;
  final String image;
  final String language;

  IndexPodcast({
    this.id,
    this.url,
    this.title,
    this.description,
    this.itunesId,
    this.author,
    this.image,
    this.language,
  });

  factory IndexPodcast.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return IndexPodcast(
        id: json['id'],
        url: json['url'],
        title: json['title'],
        description: json['description'],
        itunesId: json['itunesId'],
        author: json['author'],
        image: json['image'],
        language: json['language']);
  }
}
