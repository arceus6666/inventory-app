import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rose_store/screens/login.dart';
import 'package:rose_store/widgets/add.dart';
import 'package:rose_store/widgets/list.dart';
import 'package:rose_store/widgets/take-picture.dart';
// import 'package:rose_store/widgets/grid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      title: 'Routes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/ip',
      routes: {
        '/ip': (context) => LoginForm(),
        '/main': (context) => ItemsList(),
        '/pic': (context) => TakePictureScreen(camera: firstCamera),
        '/add': (context) => NewItemForm(),
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  // final CameraDescription cam;

  // MyApp({
  //   Key key,
  //   @required this.cam,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list_alt)),
              Tab(icon: Icon(Icons.add_box)),
            ],
          ),
          title: Text('Rose\'s Store'),
          backgroundColor: Colors.green.shade900,
        ),
        body: TabBarView(
          children: [
            ItemsList(),
            // ItemsGrid(),
            NewItemForm(),
          ],
        ),
      ),
    );
  }
}
