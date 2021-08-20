import 'package:chat_clone/helper/authenticate.dart';
import 'package:chat_clone/helper/constants.dart';
import 'package:chat_clone/helper/helperfunction.dart';
import 'package:chat_clone/screens/conversation_screen.dart';
import 'package:chat_clone/screens/search.dart';
import 'package:chat_clone/services/auth.dart';
import 'package:chat_clone/services/database.dart';
import 'package:chat_clone/widgets/customTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream<QuerySnapshot> ?chatRoomStream;

  Widget chatRoomList(){
    return  StreamBuilder<QuerySnapshot>(
      stream: chatRoomStream,
        builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            var chats = (snapshot.data!.docs[index].data()) as Map;
            print( snapshot.data!.docs[index].data());
            return ChatRoomTile(
              chatRoomId: chats['chatroomId'],
              userName: chats['users'].where((chat) => chat!=Constants.myName).first,
            );
          }): Container();
        },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
     databaseMethods.getChatRooms(Constants.myName).then((val){
       setState(() {
         chatRoomStream = val;
       });
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "Assets/images/logo.png",
          height: 40,
        ),
        actions: [
         GestureDetector(
           onTap: (){
             authMethods.signOut();
             Navigator.pushReplacement(context, MaterialPageRoute(
                 builder: (context)=>Authenticate()
             ));
           },
           child: Container(
             padding: EdgeInsets.symmetric(horizontal:16 ),
               child: Icon(Icons.exit_to_app_outlined)
           ),
         )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.search_outlined),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()
          )
          );
        },
      ) ,
    );
  }
}


class ChatRoomTile extends StatelessWidget {
  final String?  userName;
  final String? chatRoomId;
  const ChatRoomTile({Key? key, this.userName, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId:chatRoomId!)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding:EdgeInsets.symmetric(horizontal:24, vertical: 16 ) ,
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child:Text("${userName!.substring(0,1)
                  .toUpperCase()}") ,
            ),
            SizedBox(width: 10 ,),
            Text(userName!,style: mediumTextstyle(),)
          ],
        ),
      ),
    );
  }
}
