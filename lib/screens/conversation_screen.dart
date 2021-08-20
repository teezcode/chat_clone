import 'package:chat_clone/helper/constants.dart';
import 'package:chat_clone/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

   ConversationScreen({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController message = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream?  chatMessageStream;

  Widget ChatMessageList(){
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("ChatRoom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .orderBy("time", descending: false)
            .snapshots(),
          builder: (context, snapshot) {
          dynamic data = snapshot.data;
          if(snapshot.data!= null){
            return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index){
                  var message = (data.docs[index].data()) as Map;
                  return MessageTile(
                      message ["message"],
                      message ["sendBy"] == Constants.myName
                  );
                });
          } else{
            return const Text("no data");
             }
          },
      );
  }

  sendMessage(){
    if(message.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message":message.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId ,messageMap);
      message.text = "";
    }

  }
  @override
  void initState() {
    // databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
    //   setState(() {
    //     chatMessageStream = val;
    //   });
    // });
    chatMessageStream = databaseMethods.getConversationMessages(widget.chatRoomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Assets/images/logo.png',height: 50),
      ),
      body:Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color:Color(0x54ffffff) ,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: message,
                          style:TextStyle(
                            color: Colors.white,
                          ) ,
                          decoration: InputDecoration(
                              border:InputBorder.none ,
                              hintText: "Message......",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              )
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                       sendMessage();
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
                          child: Image.asset("Assets/images/send.png")
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ) ,
    );
  }
}

class MessageTile extends StatelessWidget {
  final String?  message;
  final bool  isSendByMe;
  const MessageTile (this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:isSendByMe ? 0:24 ,right: isSendByMe ? 24: 0),
      margin:EdgeInsets.symmetric(vertical: 8) ,
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
              ]
          ),
        borderRadius:isSendByMe ? BorderRadius.only(topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomLeft: Radius.circular(23)
        ) : BorderRadius.only(topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
        ),
      ),
        child: Text(message!,style:
        TextStyle(
            color: Colors.white,
            fontSize: 17
        )
        ),
      ),
    );
  }
}

