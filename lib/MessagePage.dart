import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:software_engineer/ChatPage.dart';
import 'package:software_engineer/SearchPage.dart';
import 'progress.dart';
import 'auth.dart';
import 'PageLayout.dart';
import 'package:timeago/timeago.dart' as timeago;


class MessagePage extends StatefulWidget {
  final String currentUserId;
  final String userId;
  MessagePage({this.currentUserId,this.userId});
  @override
  MessageState createState() => MessageState();
}
final friRef = Firestore.instance.collection('friend');

class MessageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Messages"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Log out"),
              onTap: (){
                Auth.logout();
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FriendStream(),
          ]
        )
      ),
    );
  }
}

class FriendStream extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: friRef.orderBy('time',descending: true)
      .snapshots(),// messages show to bottom of the list
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return linearProgress();
        }          
          final friends = snapshot.data.documents;
          List<FriendView> friendBubs = [];
          for (var message in friends) {
            final id = message.documentID;
            final friUser1 = message.data['user1'];
            final friUser2 = message.data['user2'];
            final friEmail = message.data['email'];
            final messageTime = message.data['time'];

            final friendBub = FriendView(
              id: id,
              user1: friUser1,
              user2: friUser2,
              email: friEmail, 
              time: messageTime,
            );

            friendBubs.add(friendBub);
          }
          return Expanded( // use this cause listview will take all the screen
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
              children: friendBubs,
            )
          );
      });
  }
}
class FriendView extends StatelessWidget{
  FriendView({this.id, this.user1, this.user2, this.email,this.time});
  final String id;
  final String email;
  final String user1;
  final String user2;
  final Timestamp time;

  @override
  Widget build(BuildContext context){
    return ListTile(
      title: Text(email),
      subtitle: Text(timeago.format(time.toDate())),
      onTap: () { 
        Navigator.push(context, MaterialPageRoute(  
        builder: (_) => ChatScreen(userId: id)
          ),
        );
      }
    );
  }
}
