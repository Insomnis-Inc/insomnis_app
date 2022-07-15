class Interest {
  final String id;
  final String name;
  final String image;

  Interest({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(id: json['id'], name: json['name'], image: json['image']);
  }
}
