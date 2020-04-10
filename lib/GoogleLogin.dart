import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:software_engineer/PageLayout.dart';

class GoogleLogin extends StatefulWidget {
  @override
  LoginGoogle createState() => LoginGoogle();
}

enum FormType { login, register }

class LoginGoogle extends State<GoogleLogin> {
  final formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save(); // saves data
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
//        FirebaseUser user = (await FirebaseAuth.instance
////            .createUserWithEmailAndPassword(
////                email: _email, password: _password)) as FirebaseUser;

        final user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          firebaseUser = await _auth.currentUser();
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }
        }

        print('Signed in; ${firebaseUser.uid}');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    setState(() {
      _formType = FormType.register;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Flutter login demo'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                // textform
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value.isEmpty
                    ? 'Email can\'t be empty'
                    : null, // if emailTextfield is empty error message
                onSaved: (value) => _email = value, // this saves it
                keyboardType: TextInputType
                    .emailAddress, // this will make they keyboard more suitable to emails
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value,
              ),
              RaisedButton(
                child: Text('Login', style: TextStyle(fontSize: 20.0)),
                onPressed: validateAndSubmit,
              ),
              FlatButton(
                child:
                    Text('Create an account', style: TextStyle(fontSize: 20.0)),
                onPressed: moveToRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
