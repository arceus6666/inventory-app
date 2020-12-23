import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rose_store/constants.dart';
import 'package:rose_store/models/item.dart';
import 'package:rose_store/schemas/item.dart';
import 'package:rose_store/helpers/http.dart' as HttpClient;

class ItemsList extends StatefulWidget {
  // final Storage storage = Storage();
  // ItemsList({Key key, @required this.storage}) : super(key: key);

  @override
  ItemsListState createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {
  List<Item> items = [];

  fetch() async {
    final resp = await HttpClient.httpGet();
    print('*********************************');
    print(resp);
    print('*********************************');
    // var r = [];
    setState(() {
      // var data = fetch();
      // print(data);
      // fetch();
      for (Map i in resp) {
        print(i);
        items.add(Item.fromJson(i));
      }
    });
    // for (var i = 0; i < resp.body.length; i++) {
    //   print(resp.body[i]);
    //   // r.add(Item.fromJson(jsonDecode(resp.body[i])));
    // }
    // return r;
  }

  @override
  void initState() {
    super.initState();
    // widget.storage.readStorage().then((value) {
    //   // print('items list');
    //   setState(() {
    //     items = value;
    //   });
    // });
    // setState(() {
    // var data = fetch();
    // print(data);
    fetch();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Items')),
        backgroundColor: Colors.green.shade900,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: 'Name: ',
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: '${items[index].name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
              subtitle: RichText(
                text: TextSpan(
                  text: 'Price: ',
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: '${items[index].price}\$',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
              // leading: Image(
              //   image: AssetImage(
              //     'assets/${items[index].image}',
              //   ),
              //   // height: 250,
              //   // width: 250,
              //   fit: BoxFit.cover,
              // ),
              leading: Image.network(
                '$URL/${items[index].image}',
                fit: BoxFit.cover,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () {
                  setState(() {
                    HttpClient.httpDelete(items[index].id);
                    items.removeAt(index);
                    // widget.storage.writeStorage(items);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/add');
        },
        child: Icon(Icons.add_box),
        backgroundColor: Colors.greenAccent.shade700,
      ),
    );
  }
}
