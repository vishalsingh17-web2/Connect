import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) {
    var x = FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
    return (x);
  }

  getUserByEmail(String email) {
    var x = FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    return (x);
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfo(userMap) async {
    await FirebaseFirestore.instance
        .collection("users")
        .add(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRoom(String username) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
