import 'package:flutter/material.dart';
import 'User.dart';
import 'DatabaseService.dart';
import 'StorageService.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:software_engineer/User.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MyCustomForm extends StatefulWidget {
  final User user;
  MyCustomForm({this.user});

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _userHandle = '';
  String _imageUser = '';
  Timestamp _time;
  //String _text = '';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _username = widget.user.username;
    _userHandle = widget.user.email;
    /*if (widget.user.profileImageUrl.isEmpty) {
      _imageUser =
          'https://firebasestorage.googleapis.com/v0/b/fullertonmessenger.appspot.com/o/user_placeholder.png?alt=media&token=801e18ef-c970-47b0-8d7f-983690fb58ca';
    } else {
      _imageUser = widget.user.profileImageUrl;
    }*/
    _imageUser = widget.user.profileImageUrl;
  }

  /* getUser() async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.user).get();
  }*/

  _submit() async {
    Firestore.instance.collection('posts').add({
      'user': _username,
      'imageUser': _imageUser,
      //'https://firebasestorage.googleapis.com/v0/b/fullertonmessenger.appspot.com/o/user_placeholder.png?alt=media&token=801e18ef-c970-47b0-8d7f-983690fb58ca',
      'text': myController.text,
      'userHandle': _userHandle,
      'time': _time,
    });
    //DatabaseService.updatePost(post);

    Navigator.pop(context);
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: myController,
                    decoration: InputDecoration(hintText: 'Write your post'),
                  ),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          print(_username);
          DateTime currentPhoneDate = DateTime.now(); //DateTime

          Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
          _time = myTimeStamp;
          _submit();
          /*return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );*/
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.check),
      ),
    );
  }
}

