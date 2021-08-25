import 'package:connect/Services/Auth.dart';
import 'package:connect/Widget/MyAppBar.dart';
import 'package:connect/helper/Constants.dart';
import 'package:connect/helper/Database.dart';
import 'package:connect/helper/helperFunction.dart';
import 'package:flutter/material.dart';

import 'ChatRoom.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods dataMethods = DatabaseMethods();
  HelperFunction helperMethods = HelperFunction();

  final _formKey = GlobalKey<FormState>();
  void signUp(){
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
    }
    authMethods.SignUpWithEmailandPassword(email.text, password.text).then((value){
      Map<String, String> userMap = {'name':username.text,'email':email.text};
      dataMethods.uploadUserInfo(userMap);
      HelperFunction.saveUserloggedIn(true);
      HelperFunction.saveUseremail(email.text);
      HelperFunction.saveUsername(username.text);
      setState(() {
        Constants.myName = username.text;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ChatRooms()));
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,"Connect"),
      body: isLoading?Scaffold(body: Center(child: CircularProgressIndicator()),):SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.89,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Form(
                key: _formKey,
                child: Column(
                children: [
                  TextFormField(
                    validator: (val){
                        return val!.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                      },
                      controller: username,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: DecorateInput('Username')),
                  TextFormField(
                    validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                            null : "Enter correct email";
                      },
                      controller: email,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: DecorateInput('Email')),
                  TextFormField(
                    validator:  (val){
                        return val!.length < 6 ? "Password length is too short, atleast 6" : null;
                      },
                      controller: password,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: DecorateInput('Password')),
                ],
              )),
              SizedBox(height: 8),
              SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                  signUp();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.blueAccent.shade100,
                        Colors.blueAccent.shade200,
                        Colors.blueAccent.shade400,
                      ]),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white10, Colors.white24, Colors.white70]),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  "Sign Up with Google",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  widget.toggle();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have Account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Log In ",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
