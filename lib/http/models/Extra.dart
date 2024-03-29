import 'package:brokerstreet/custom_colors.dart';

class Extra {
  final String? id;
  final String? name;
  final String? image;
  final bool canAdd;

  Extra(
      {this.id = "non",
      this.canAdd = false,
      required this.name,
      required this.image});

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(id: json['id'], name: json['name'], image: testImage);
  }
}
