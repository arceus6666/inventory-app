import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rose_store/schemas/item.dart';
import 'package:rose_store/helpers/storage.dart';

class ItemsGrid extends StatefulWidget {
  final Storage storage = Storage();
  // ItemsGrid({Key key, @required this.storage}) : super(key: key);

  @override
  ItemsGridState createState() => ItemsGridState();
}

class ItemsGridState extends State<ItemsGrid> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readStorage().then((value) {
      // print('items list');
      setState(() {
        items = value;
      });
    });
    // print(items.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Items')),
        backgroundColor: Colors.green.shade900,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: items
            .map((e) => Center(
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.network(
                          'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     '${e.name}',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      Stack(
                        children: [
                          Positioned(
                            top: 3.0,
                            left: 3.0,
                            child: Text(
                              '${e.name}',
                              style: TextStyle(
                                color: Colors.white,
                              ).copyWith(color: Colors.black.withOpacity(0.9)),
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: Text(
                              '${e.name}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
