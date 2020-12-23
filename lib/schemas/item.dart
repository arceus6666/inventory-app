import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Item {
  String id;
  String name;
  String price;
  String image;

  Item(String n, String p, [String id = '', String image = 'blank.jpg']) {
    this.id = id.isEmpty ? uuid.v4() : id;
    this.name = n;
    this.price = p;
    this.image = image;
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['name'],
      '${json['price']}',
      json['_id'],
      json['image'],
    );
  }
}
