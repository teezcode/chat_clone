
import 'package:chat_clone/helper/helperfunction.dart';
import 'package:chat_clone/services/auth.dart';
import 'package:chat_clone/services/database.dart';
import 'package:chat_clone/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'chatRoom_screen.dart';

class SignUp extends StatefulWidget {
  final Function?  toggle;
  const SignUp({Key? key, this.toggle}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  HelperFunctions helperFunctions = HelperFunctions();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(email.text, password.text)
          .then((val){
        //print("${val.uId}");
        Map<String, String> userInfoMap ={
          "name": username.text,
          "email": email.text
        };
        HelperFunctions.saveUserEmailSharedPreference(email.text);
        HelperFunctions.saveUserNameSharedPreference(username.text);

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Assets/images/logo.png',height: 50),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height- 90,
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          validator:(val){
                            return val!.isEmpty || val.length < 4 ?
                            "Please enter a valid username" : null ;
                          } ,
                          controller: username,
                          hintText: 'Username',
                        ),
                        SizedBox(height: 10,),
                        CustomTextField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                            null : "Enter correct email";
                          },
                          controller: email,
                          hintText: 'Email',
                        ),
                        SizedBox(height: 10,),
                        CustomTextField(
                          validator:  (val){
                            return val!.length < 6 ? "Enter Password 6+ characters" : null;
                          },
                          controller: password,
                          hintText: 'Password',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    alignment:Alignment.centerRight ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                      child: Container(
                        child: Text("Forgot Password ?",style: TextStyle(color: Colors.white54),),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      signMeUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC)
                              ]
                          ),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign Up",style:
                      TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      )
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign In with Google",style:
                    TextStyle(
                        color: Colors.black,
                        fontSize: 17
                    )
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have account? ",style: mediumTextstyle(),
                      ),

                      GestureDetector(
                        onTap: (){
                          widget.toggle!();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Sign In Now ",style:TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline
                          ),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     //widget.toggleView();
                      //   },
                      //
                      // ),
                    ],
                  ),
                  SizedBox(height: 90,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
