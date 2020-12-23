import 'package:flutter/material.dart';
import 'package:rose_store/constants.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      title: 'API IP',
      home: Scaffold(
        appBar: AppBar(
          title: Text('API IP'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  var ipt = value.split('.');
                  if (value.isEmpty || ipt.length != 4) {
                    return 'Please enter a valid ip';
                  }
                  var ip = ipt.map((e) {
                    try {
                      return num.parse(e);
                    } catch (e) {
                      return -1;
                    }
                  }).toList();
                  if (ip[0] < 0 ||
                      ip[0] > 255 ||
                      ip[1] < 0 ||
                      ip[1] > 255 ||
                      ip[2] < 0 ||
                      ip[2] > 255 ||
                      ip[3] < 0 ||
                      ip[3] > 255) {
                    return 'Please enter a valid ip';
                  }
                  URL = 'http://${ip[0]}.${ip[1]}.${ip[2]}.${ip[3]}';
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      // Scaffold.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Processing Data'),
                      //   ),
                      // );
                      // Navigator.pushNamed(context, '/second');
                      Navigator.pushReplacementNamed(context, '/main');
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
