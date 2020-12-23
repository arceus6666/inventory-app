// import 'dart:async';
import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:path/path.dart' show join;
import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:rose_store/schemas/item.dart';
import 'package:rose_store/helpers/storage.dart';
// import '../widgets/take-picture.dart';
import 'package:rose_store/constants.dart' as Globals;

// import 'package:http/http.dart' as http;
import 'package:rose_store/helpers/http.dart' as HttpClient;
import 'package:rose_store/helpers/files.dart' as FileClient;

class NewItemForm extends StatefulWidget {
  final Storage storage = Storage();
  // final CameraDescription camera;

  // NewItemForm({
  //   Key key,
  //   @required this.camera,
  // }) : super(key: key);

  @override
  NewItemFormState createState() => NewItemFormState();
}

class NewItemFormState extends State<NewItemForm> {
  // List<Item> items = [];
  File file;
  // CameraController _cameraController;
  // Future<void> _initializeController;

  final TextEditingController _nameTextFieldController =
      TextEditingController();
  final TextEditingController _priceTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      file = Globals.memo['picture'];
    } catch (e) {}
    _nameTextFieldController.text = Globals.memo['name'] ?? '';
    _priceTextFieldController.text = Globals.memo['price'] ?? '';
    // widget.storage.readStorage().then((value) => items = value);
    // _cameraController = CameraController(
    //   widget.camera,
    //   ResolutionPreset.high,
    // );
    // _initializeController = _cameraController.initialize();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _nameTextFieldController.dispose();
    _priceTextFieldController.dispose();
    // _cameraController.dispose();
    super.dispose();
  }

  // _printLatestValue() {
  //   print("Second text field: ${myController.text}");
  // }

  changeImage(File image) {
    setState(() {
      Globals.memo['picture'] = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return TakePictureScreen(camera: widget.camera);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'New Item',
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Globals.memo['picture'] = null;
            Navigator.pushReplacementNamed(context, '/main');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameTextFieldController,
                decoration: InputDecoration(
                  // border: InputBorder.,
                  labelText: 'Item Name: ',
                ),
                onChanged: (text) {
                  Globals.memo['name'] = text;
                  // print("First text field: $text");
                },
              ),
              TextField(
                controller: _priceTextFieldController,
                decoration: InputDecoration(
                  labelText: 'Item Price: ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (text) {
                  Globals.memo['price'] = text;
                },
              ),
              if (file != null)
                Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              // if (file != null) Text('not null'),
              // Visibility(
              //   child: Image.file(file),
              //   visible: file != null,
              // ),
              // RaisedButton(
              //   onPressed: () {
              //     print(Globals.memo['picture']);
              //   },
              //   child: Text('show image'),
              // ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    showAlertDialog(context);
                  });
                },
                child: Text('Upload image'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_nameTextFieldController.text.isNotEmpty &&
                        _priceTextFieldController.text.isNotEmpty &&
                        _priceTextFieldController.text != '0') {
                      // If the form is valid, display a Snackbar.
                      // Scaffold.of(context).showSnackBar(
                      //   SnackBar(
                      //     duration: const Duration(seconds: 2),
                      //     content: Text('Processing Data'),
                      //   ),
                      // );
                      Item item = new Item(_nameTextFieldController.text,
                          _priceTextFieldController.text);

                      HttpClient.upload(
                        {
                          'name': _nameTextFieldController.text,
                          'price': _priceTextFieldController.text,
                          // 'id': item.id,
                        },
                        Globals.memo['picture'],
                      ).then((value) {
                        item.image = value['image'];
                        item.id = value['_id'];
                        // save(item);
                        _nameTextFieldController.text = '';
                        _priceTextFieldController.text = '';
                        Globals.memo['name'] = null;
                        Globals.memo['price'] = null;
                        Globals.memo['picture'] = null;
                        file = null;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Created'),
                              actions: [
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          Navigator.pushReplacementNamed(context, '/main');
                        });
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please fill name and price'),
                            actions: [
                              FlatButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: RichText(
      text: TextSpan(
        text: 'Upload image',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
    ),
    content: Text('What do you want to do?'),
    actions: [
      FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text('Choose image'),
        onPressed: () {
          FileClient.pickFile().then((value) {
            Globals.memo['picture'] = File(value.path);
            // print(Globals.memo['picture']);
            // Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushReplacementNamed(context, '/add');
          });
        },
      ),
      FlatButton(
        child: Text('Take picture'),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/pic');
        },
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
