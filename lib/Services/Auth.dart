import 'package:connect/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _useFromFirebaseUser(var user){
    return user != null ? Users(user.uid): null; 
  }

  Future SignInWithEmailandPassword(email, password)async{
    try{
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      var firebaseUser = result.user;
      return(_useFromFirebaseUser(firebaseUser));
    }catch(e){
      print(e.toString());
    }
  }

  Future SignUpWithEmailandPassword(String email, String password) async{
    try{
      var result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var firebaseUser = result.user;
    }catch(e){
      print(e.toString());
    }
  }

  Future ResetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }


  Future SignOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}