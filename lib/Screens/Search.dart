import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Screens/Conversation.dart';
import 'package:connect/Widget/MyAppBar.dart';
import 'package:connect/helper/Constants.dart';
import 'package:connect/helper/Database.dart';
import 'package:connect/helper/helperFunction.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController username = TextEditingController();
  DatabaseMethods dataMethods = DatabaseMethods();
  QuerySnapshot? searchSnapshot;
  int count = 0;

  Widget searchTile(String username, String email) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListTile(
        title: Text(username,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(email,
            style: TextStyle(
              color: Colors.white,
            )),
        trailing: GestureDetector(
          onTap: () {
            createChatRoom(username);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.blueAccent.shade700,
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              "Message",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  getChatRoomId(String a, String b) {
    var x = [a,b];
    x.sort();
    return(x[0]+"_"+x[1]);
  }

  initiateSearch() async {
    await dataMethods.getUserByUsername(username.text).then((value) {
      setState(() {
        searchSnapshot = value;
        count = searchSnapshot!.docs.length;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              return searchTile(searchSnapshot!.docs[index]['name'],
                  searchSnapshot!.docs[index]['email']);
            },
          )
        : Container();
  }

  createChatRoom(String username) async {
    try {
      var myName = await HelperFunction.getUsername();
      String chatRoomId =
          getChatRoomId(username, await HelperFunction.getUsername());
          print(chatRoomId);
      List<String> users = [username, await HelperFunction.getUsername()];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      dataMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(username,chatRoomId, myName)));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Search your friends"),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white10,
                      Colors.white24,
                      Colors.white54
                    ]),
                    borderRadius: BorderRadius.circular(30)),
                child: ListTile(
                  title: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: username,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      focusColor: Colors.white,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black12,
                          Colors.black26,
                          Colors.black38,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: () {
                        initiateSearch();
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: searchList()),
            ],
          ),
        ),
      ),
    );
  }
}
