class HashTagApi {
  final String id;
  final String tag;
  final String url;

  HashTagApi({
    required this.id,
    required this.tag,
    required this.url,
  });

  factory HashTagApi.fromJson(Map<String, dynamic> json) {
    return HashTagApi(id: json['id'], tag: json['tag'], url: json['url']);
  }
}
