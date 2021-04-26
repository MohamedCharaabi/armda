class IndexEpisode {
  final int id;
  final String link;
  final String title;
  final String description;
  final String datePublishedPretty;
  final String enclosureUrl;
  final int enclosureLength;
  final String image;
  final String language;
  final String transcriptUrl;

  IndexEpisode({
    this.id,
    this.link,
    this.title,
    this.description,
    this.datePublishedPretty,
    this.enclosureUrl,
    this.enclosureLength,
    this.image,
    this.language,
    this.transcriptUrl,
  });

  factory IndexEpisode.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return IndexEpisode(
      id: json['id'],
      link: json['link'],
      title: json['title'],
      description: json['description'],
      datePublishedPretty: json['datePublishedPretty'],
      enclosureUrl: json['enclosureUrl'],
      enclosureLength: json['enclosureLength'],
      image: json['image'],
      language: json['language'],
      transcriptUrl: json['transcriptUrl'],
    );
  }
}
