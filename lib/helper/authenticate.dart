import 'package:connect/Screens/SignIn.dart';
import 'package:connect/Screens/SignUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    if(showSignIn==true){
      setState(() {
        showSignIn = false;
      });
    }else{
      setState(() {
        setState(() {
          showSignIn = true;
        });
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}