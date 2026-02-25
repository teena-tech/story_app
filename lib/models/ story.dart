class Story {
  final String title;
  final String description;
  final String image;
  final String audio;

  Story({
    required this.title,
    required this.description,
    required this.image,
    required this.audio,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      audio: json['audio'],
    );
  }
}
