import 'package:connect/Widget/MyAppBar.dart';
import 'package:connect/helper/Database.dart';
import 'package:connect/helper/helperFunction.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String name;
  final String chatRoomId;
  final String myName;
  ConversationScreen(this.name, this.chatRoomId, this.myName);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream? chatMessageStream;
  DatabaseMethods data = DatabaseMethods();
  TextEditingController message = TextEditingController();
  Future<dynamic> myName = HelperFunction.getUsername();

  sendMessage() async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": message.text,
        "sendBy": await HelperFunction.getUsername(),
        "time": DateTime.now()
      };
      data.addConversationMessages(widget.chatRoomId, messageMap);
      message.text = "";
    }
  }

  @override
  void initState() {
    data.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.docs[index]['message'],
                      widget.myName == snapshot.data.docs[index]['sendBy'],
                      context);
                });
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, widget.name),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: chatMessageList(),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Center(
                child: ListTile(
                  title: TextFormField(
                    controller: message,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: sendMessage,
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    splashColor: Colors.blue,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget MessageTile(String message, bool isSendByMe, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: isSendByMe ? Colors.blue : Colors.black,
        borderRadius: isSendByMe
            ? BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    ),
  );
}
