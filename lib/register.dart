import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RegisterPage extends StatefulWidget {
  // This widget is the root of your application.
  static final String id = 'Register_Page';
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
final formKey = GlobalKey<FormState>();
String _email, _password, _username;

_submit() {
  if(formKey.currentState.validate()){
    formKey.currentState.save();
    Auth.signUpUser(context, _username, _email, _password);
  }
}
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
            child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                    'assets/images/fullerton_logo.png',
                    height: 45.0,
                  ),
                SizedBox(
                    child: TypewriterAnimatedTextKit(
                     text: ['Register'],
                     textStyle: TextStyle(
                       fontSize: 20.0,
                       fontWeight: FontWeight.bold,
                     ),
                     textAlign: TextAlign.start,
                    ),
                  ),
                Form(key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'username'),
                        // trim makes whitespace unvalid as well
                        validator: (input) => input.trim().isEmpty ? 'Enter a valid username' : null,
                        onSaved: (input) => _username = input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@') ? 'Please enter a valid email' : null,
                        onSaved: (input) => _email = input,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (input) => input.length < 6 ? 'Must be at lease 6 characters' : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: OutlineButton(
                        onPressed: _submit,
                        child: Text(
                          'Register',
                        ),

                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
        );
    }
}

