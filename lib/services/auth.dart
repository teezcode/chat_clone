import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_clone/model/user.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebaseUser(User? user){
    return user!=null?Users(userId: user.uid):null;
  }

  Future  signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      User firebaseUser = result.user!;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print (e.toString());
    }
  }
  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail
        (email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch (e){

    }
  }
}