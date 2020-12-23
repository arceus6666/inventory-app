import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rose_store/schemas/item.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/storage.txt');
  }

  Future<List<Item>> readStorage() async {
    try {
      final file = await _localFile;
      List<Item> items = [];
      List<String> contents = await file.readAsLines();
      contents.forEach((element) {
        var line = element.split(';');
        // print(line);
        if (line.length == 3) {
          items.add(new Item(line[0], line[1], line[2]));
        }
      });
      return items;
    } catch (e) {
      // print('error');
      return [];
    }
  }

  Future<File> writeStorage(List<Item> items) async {
    final file = await _localFile;
    String data = '';
    for (var item in items) {
      data = '$data\n${item.name};${item.price};${item.id}';
    }
    return file.writeAsString(data);
  }
}
