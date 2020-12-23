import 'dart:io';
import 'dart:convert';

import 'package:rose_store/constants.dart';
import 'package:http/http.dart' as http;

httpPost(body) async {
  var res = await http.post('$URL/items', body: body);
  return res;
}

Future<List> httpGet() async {
  var data = await http.get('$URL/items');
  return json.decode(data.body);
}

httpDelete(id) async {
  print('deleting $id');
  var data = await http.delete('$URL/items/$id');
  return json.decode(data.body);
}

upload(body, File image) async {
  print('upload');
  var uri = Uri.parse('$URL/items');
  var req = http.MultipartRequest('POST', uri)
    ..fields['name'] = body['name']
    ..fields['price'] = body['price']
    // ..fields['id'] = body['id']
    ..files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );
  var res = await req.send();
  var json = jsonDecode(await res.stream.bytesToString());
  print(json);
  return json;
}
