import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{
  getUserByUsername( String username) async{
    return await FirebaseFirestore.instance.collection("users")
        .where("name" , isEqualTo: username)
        .get();
  }

  getUserByUserEmail( String userEmail) async{
    return await FirebaseFirestore.instance.collection("users")
        .where("email" , isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users")
        .add(userMap);
  }
  createChatRoom(String chartRoomId,chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chartRoomId).set(chatRoomMap).catchError((e){
         print(e.toString()) ;
    });
  }
  addConversationMessages(String chatRoomId,messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){
          print(e.toString());
    });
  }
  getConversationMessages(String chatRoomId){
    return FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async{
      return FirebaseFirestore.instance.
      collection("ChatRoom")
          .where("users", arrayContains: userName)
          .snapshots();
  }
}