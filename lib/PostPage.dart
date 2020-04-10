import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:software_engineer/MessagePage.dart';
import 'User_data.dart';
import 'package:software_engineer/User.dart';
import 'edit_profile_page.dart';
import 'DatabaseService.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'PageLayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;


class ProfilePage extends StatefulWidget {
  final String currentUserId;
  final String userId;

  ProfilePage({this.currentUserId, this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      followerCount = userFollowerCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      followingCount = userFollowingCount;
    });
  }

  _followOrUnfollow() {
    if (isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing = false;
      followerCount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing = true;
      followerCount++;
    });
  }

  // showChat(User user){
  //   user.id == Provider.of<UserData>(context).currentUserId
  //   ? Container() : IconButton(
  //     icon: Icon(Icons.message),
  //     onPressed: () => Navigator.push(context, MaterialPageRoute(
  //       builder: (_) => ChatScreen(
  //         userId: user.id,
  //         username: user.username,
  //       ),
  //     ),
  //   ),
  //   );
  // }

  addMessage(User user){
    return user.id == Provider.of<UserData>(context).currentUserId
    ? Container() : IconButton(
      icon: Icon(Icons.message),
      onPressed: () => addMessagePost(user)
    );
  }

  addMessagePost(User user){
      Firestore.instance.collection('friend')
      .add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'user1': Provider.of<UserData>(context).currentUserId,
        'user2': user.id,
        'email': user.email,
        'time': Timestamp.now(),
      });
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => MainPage()
      ),
    );
  }
  
  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
      width: 200.0,
      child: FlatButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditProfilePage(
              user: user,
            ),
          ),
        ),
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    )
        : Container(
      width: 200.0,
      child: FlatButton(
        onPressed: _followOrUnfollow,
        color: isFollowing ? Colors.grey[200] : Colors.blue,
        textColor: isFollowing ? Colors.black : Colors.white,
        child: Text(
          isFollowing ? 'Unfollow' : 'Follow',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  Column BuildStatColumn (String label, int number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          label,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () { Navigator.pop(context); },
        // ),
        title: Text('Profile'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.message),
        //     onPressed: () {
        //     //addMessagePost();
        //     }
        //   ),
        // ],
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: usersRef.document(widget.userId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User user = User.fromDoc(snapshot.data);
            return ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        // place for user to add their avatar
                        radius: 70,
                        backgroundColor: Colors.grey,
                        backgroundImage: user.profileImageUrl.isEmpty
                            ? AssetImage('assets/images/user_placeholder.jpg')
                            : CachedNetworkImageProvider(user.profileImageUrl),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      user.username,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      user.bio,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                          fontSize: 18.0),
                    ),
                    _displayButton(user),
                    addMessage(user),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          BuildStatColumn("Posts", postCount),
                          BuildStatColumn("Follower", followerCount),
                          BuildStatColumn("Following", followingCount),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4.0,4.0,4.0,0.0),
                    ),
                    Card(
                      // place for user to input their name
                      child: ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Container(
                          child: Text(
                            user.name,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.contact_mail),
                        title: Container(
                          child: Text(
                            user.email,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.contact_phone),
                        title: Container(
                          width: 250,
                          child: Text(
                            user.phone,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
