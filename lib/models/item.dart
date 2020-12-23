import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Item2 {
  String id;
  String name;
  String price;
  String image;

  Item2(String n, String p, [String id = '', String image = 'blank.jpg']) {
    this.name = n;
    this.price = p;
    this.id = id.isEmpty ? uuid.v4() : id;
    this.image = image;
  }

  factory Item2.fromJson(Map<String, dynamic> json) {
    return Item2(
      json['name'],
      json['price'],
      json['id'],
      json['image'],
    );
  }
}
