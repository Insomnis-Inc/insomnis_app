class Extra {
  final String id;
  final String name;

  Extra({
    required this.id,
    required this.name,
  });

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(id: json['id'], name: json['name']);
  }
}
