import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constants.dart';

final _firestore = FirebaseFirestore.instance;
String username = 'User';
String email = 'user@example.com';
String? messageText;
User? loggedInUser;

class ChatterScreen extends StatefulWidget {
  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getMessages();
  }

  void getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
        setState(() {
          username = loggedInUser!.displayName ?? "User";
          email = loggedInUser!.email ?? "user@example.com";
        });
      }
    } catch (e) {
        Fluttertoast.showToast(
          msg: 'Something Went Wrong: ${e.toString()}',
          toastLength: Toast.LENGTH_LONG, // Use Toast.LENGTH_LONG for longer duration
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3, // Set the duration for iOS and web
          backgroundColor: Colors.deepPurple[900],
          textColor: Colors.white,
        );
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 10),
          child: Container(
            decoration: const BoxDecoration(
                // color: Colors.blue,
                // borderRadius: BorderRadius.circular(20)
                ),
            constraints: const BoxConstraints.expand(height: 1),
            child: LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.blue[100],
            ),
          ),
        ),
        backgroundColor: Colors.white10,
        // leading: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png'),),
        // ),
        title:const Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Chatter',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.deepPurple),
                ),
                Text('by ishandeveloper',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 8,
                        color: Colors.deepPurple))
              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: const Icon(Icons.more_vert),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[900],
              ),
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png"),
              ),
              onDetailsPressed: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              subtitle: const Text("Sign out of this account"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(),
          Container(
            padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation:5,
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,top:2,bottom: 2),
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: chatMsgTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  shape: const CircleBorder(),
                  color: Colors.blue,
                  onPressed: () {
                    chatMsgTextController.clear();
                    _firestore.collection('messages').add({
                      'sender': username,
                      'text': messageText,
                      'timestamp':DateTime.now().millisecondsSinceEpoch,
                      'senderemail': email
                    });
                  },
                  child:const Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.send,color: Colors.white,),
                  ) 
                  // Text(
                  //   'Send',
                  //   style: kSendButtonTextStyle,
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final msgText = message['text'];
            final msgSender = message['sender'];
            // final msgSenderEmail = message.data['senderemail'];
            final currentUser = loggedInUser!.displayName;

            // print('MSG'+msgSender + '  CURR'+currentUser);
            final msgBubble = MessageBubble(
                msgText: msgText,
                msgSender: msgSender,
                user: currentUser == msgSender
              );
            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }else {
          return const Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {

  const MessageBubble({required this.msgText,required this.msgSender,required this.user});
  final String msgText;
  final String msgSender;
  final bool user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender,
              style: const TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(50),
              topLeft: user ? const Radius.circular(50) : const Radius.circular(0),
              bottomRight: const Radius.circular(50),
              topRight: user ? const Radius.circular(0) : const Radius.circular(50),
            ),
            color: user ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

