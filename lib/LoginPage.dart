import 'package:flutter/material.dart';
import 'auth.dart';
import 'register.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginPage extends StatefulWidget {
  // This widget is the root of your application.
  static final String id = 'Login_Page';

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final formKey = GlobalKey<FormState>();
String _email;
String _password;
void _submit(){
  if(formKey.currentState.validate()){
    formKey.currentState.save();
    Auth.login(_email, _password);
  }
}
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                    'assets/images/fullerton_logo.png',
                    height: 80.0,
                  ),
                  SizedBox(
                    child: TypewriterAnimatedTextKit(
                     text: ['Log In'],
                     textStyle: TextStyle(
                       fontSize: 15.0,
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
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@') ? 'Please enter a valid email' : null,
                        onSaved: (input) => _email = input,
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
                    OutlineButton(
                        onPressed: _submit,
                        child: Text(
                          'Login',
                        ),
                      ),
                    SizedBox(height: 40.0,),
                    OutlineButton(
                      onPressed: (){
                        Navigator.pushNamed(context,RegisterPage.id);
                      },
                      child: Text(
                        'REGISTER',
                      ),
                      borderSide: BorderSide(color: Colors.blue),
                      shape: StadiumBorder(),
                      splashColor: Colors.white,
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
        );
    }
}
