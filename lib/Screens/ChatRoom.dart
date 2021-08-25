import 'package:connect/Screens/Conversation.dart';
import 'package:connect/Screens/Search.dart';
import 'package:connect/Services/Auth.dart';
import 'package:connect/helper/Constants.dart';
import 'package:connect/helper/Database.dart';
import 'package:connect/helper/authenticate.dart';
import 'package:connect/helper/helperFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key}) : super(key: key);

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

DatabaseMethods data = DatabaseMethods();
Stream? chatsWithUser;
String? myName;

class _ChatRoomsState extends State<ChatRooms> {
  AuthMethods authMethod = AuthMethods();
  getUserInfo() async {
    String x = await HelperFunction.getUsername();
    setState(() {
      myName = x;
      chatsWithUser = data.getChatRoom(x);
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ChatRoom",
          style: TextStyle(
            fontFamily: GoogleFonts.petitFormalScript().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                authMethod.SignOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                });
              },
              icon: Icon(Icons.exit_to_app_rounded)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: Icon(Icons.search),
      ),
      body: Container(
        child: StreamBuilder(
            stream: chatsWithUser,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return chatBox(
                          snapshot.data.docs[index]['users'], context, snapshot.data.docs[index]['chatRoomId']);
                    });
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}

Widget chatBox(List<dynamic> users, BuildContext context, String chatRoomId,) {
  return InkWell(
    onTap: (){
      Navigator.push(context,MaterialPageRoute(
        builder:(context)=> ConversationScreen(users[0]==myName?users[1]:users[0], chatRoomId, myName!)
      ));
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blueGrey.shade500,
            Colors.blueGrey.shade400,
            Colors.blueGrey.shade200,
          ]),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        users[0] != myName ? users[0] : users[1],
        style: TextStyle(
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    ),
  );
}
