import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Services/Auth.dart';
import 'package:connect/Widget/MyAppBar.dart';
import 'package:connect/helper/Constants.dart';
import 'package:connect/helper/Database.dart';
import 'package:connect/helper/helperFunction.dart';
import 'package:flutter/material.dart';

import 'ChatRoom.dart';

class SignIn extends StatefulWidget {
  Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  getUserInfo() async {
  Constants.myName = await HelperFunction.getUsername();
  }


  final __formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool isLoading = false;

  signIn() async {
    if (__formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .SignInWithEmailandPassword(email.text, password.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
              await databaseMethods.getUserInfo(email.text);
          setState(() {
            Constants.myName = userInfoSnapshot.docs[0]['name'];
          });
          HelperFunction.saveUserloggedIn(true);
          HelperFunction.saveUsername(userInfoSnapshot.docs[0]['name']);
          HelperFunction.saveUseremail(userInfoSnapshot.docs[0]['email']);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRooms()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User doesn't Exist! Please Sign Up")));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Connect"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Form(
              key: __formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "Enter correct email";
                      },
                      controller: email,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: DecorateInput('Email')),
                  TextFormField(
                      validator: (val) {
                        return val!.length < 6
                            ? "Password length is too short, atleast 6"
                            : null;
                      },
                      controller: password,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: DecorateInput('Password')),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: signIn,
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
                  "Sign In",
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
                "Sign In with Google",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                widget.toggle();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Register Now ",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
