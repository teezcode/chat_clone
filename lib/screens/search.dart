import 'package:chat_clone/helper/constants.dart';
import 'package:chat_clone/services/database.dart';
import 'package:chat_clone/widgets/customTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController search = TextEditingController();

  QuerySnapshot ?searchSnapshot;
  Widget searchList(){
    return searchSnapshot !=null ?  ListView.builder(
        itemCount: searchSnapshot!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          var user = (searchSnapshot!.docs[index].data()) as Map;
          return SearchTile(
            userName: user["name"],
            userEmail: user["email"],
          );
        }): Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(search.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatroomAndStartConversation({ String? userName}){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName!, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String,dynamic >chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ConversationScreen(chatRoomId: chatRoomId)

      )
      );
    }else {
      print("impossible!!");
    }
  }

  Widget SearchTile( {String ? userName, String? userEmail}){
    return Container(
      padding:EdgeInsets.symmetric(horizontal: 24,vertical: 16) ,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName!, style: mediumTextstyle(),),
              Text(userEmail!, style: mediumTextstyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                userName: userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message",style: mediumTextstyle(),),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
   //initiateSearch();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Assets/images/logo.png',height: 50),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color:Color(0x54ffffff) ,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: search,
                        style:TextStyle(
                          color: Colors.white,
                        ) ,
                        decoration: InputDecoration(
                          border:InputBorder.none ,
                          hintText: "Search......",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          )
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                     initiateSearch();
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36ffffff),
                              const Color(0x0ffffff)
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("Assets/images/search_white.png")
                      ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}



getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

