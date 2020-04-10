import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'MessagePage.dart';
import 'PostPage.dart';
import 'ProfilePage.dart';
import 'package:provider/provider.dart';
import 'User_data.dart';
import 'SearchPage.dart';

class MainPage extends StatefulWidget {
  final String userId;
  MainPage({this.userId});
  final String id = 'main_page';
    // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          MessagePage(),
          PostsPage(            
            currentUserId: currentUserId,
            userId: currentUserId,
          ),
          ProfilePage(
            currentUserId: currentUserId,
            userId: currentUserId,
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32.0,
            ),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.account_circle,
          //     size: 32.0,
          //   ),
          // ),
        ],
      ),
    );
  }
}
