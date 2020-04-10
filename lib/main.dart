import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'PageLayout.dart';
import 'package:provider/provider.dart';
import 'User_data.dart';
import 'LoginPage.dart';
import 'register.dart';
import 'PostPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return MainPage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fullerton Message App',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.grey[20],
          accentColor: Colors.white,
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
            color: Colors.blue,
          )
        ),
        home: _getScreenId(),
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          PostsPage.id: (context) => PostsPage(),
        },
      ),
    );
  }
}
