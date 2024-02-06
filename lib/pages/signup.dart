import 'package:chat_app/widgets/custombutton.dart';
import 'package:chat_app/widgets/customtextinput.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ChatterSignUp extends StatefulWidget {
  @override
  _ChatterSignUpState createState() => _ChatterSignUpState();
}

class _ChatterSignUpState extends State<ChatterSignUp> {
  final _auth = FirebaseAuth.instance;
  String? email;
  // String username;
  String? password;
  String? name;
  bool signingup = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      barrierEnabled: signingup,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'heroicon',
                    child: Icon(
                      Icons.textsms,
                      size: 120,
                      color: Colors.deepPurple[900],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Hero(
                    tag: 'HeroTitle',
                    child: Text(
                      'Chatter',
                      style: TextStyle(
                          color: Colors.deepPurple[900],
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  // Text(
                  //   "World's most private chatting app".toUpperCase(),
                  //   style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontSize: 12,
                  //       color: Colors.deepPurple),
                  // ),
                  CustomTextInput(
                    hintText: 'Name',
                    leading: Icons.text_format,
                    obscure: false,
                    userTyped: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  // CustomTextInput(
                  //   hintText: 'Username',
                  //   obscure: false,
                  //   leading: Icons.supervised_user_circle,
                  //   userTyped: (value) {
                  //     username = value;
                  //   },
                  // ),
                  const SizedBox(
                    height: 0,
                  ),
                  CustomTextInput(
                    hintText: 'Email',
                    leading: Icons.mail,
                    keyboard: TextInputType.emailAddress,
                    obscure: false,
                    userTyped: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  CustomTextInput(
                    hintText: 'Password',
                    leading: Icons.lock,
                    keyboard: TextInputType.visiblePassword,
                    obscure: true,
                    userTyped: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Hero(
                    tag: 'signupbutton',
                    child: CustomButton(
                        text: 'sign up',
                        accentColor: Colors.white,
                        mainColor: Colors.deepPurple,
                        onpress: () async {
                          if (name != null &&
                              password != null &&
                              email != null) {
                            setState(() {
                              signingup = true;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email!, password: password!);
                              if (newUser != null) {
                                await newUser.user!.updateDisplayName(name!);
                                Navigator.of(context).pushNamed('/chat');
                              }
                            } catch (e) {
                              setState(() {
                                signingup = false;
                              });
                              Fluttertoast.showToast(
                                msg: 'Signup Failed: ${e.toString()}',
                                toastLength: Toast
                                    .LENGTH_LONG, // Use Toast.LENGTH_LONG for longer duration
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb:
                                    3, // Set the duration for iOS and web
                                backgroundColor: Colors.deepPurple[900],
                                textColor: Colors.white,
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Signup Failed: All fields are required.',
                              toastLength: Toast
                                  .LENGTH_LONG, // Use Toast.LENGTH_LONG for longer duration
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb:
                                  3, // Set the duration for iOS and web
                              backgroundColor: Colors.deepPurple[900],
                              textColor: Colors.white,
                            );
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'or log in instead',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.deepPurple),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  const Hero(
                      tag: 'footer',
                      child: Text(
                        'Made with ♥ by ishandeveloper',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
