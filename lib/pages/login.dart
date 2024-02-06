import 'package:chat_app/widgets/custombutton.dart';
import 'package:chat_app/widgets/customtextinput.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ChatterLogin extends StatefulWidget {
  @override
  _ChatterLoginState createState() => _ChatterLoginState();
}

class _ChatterLoginState extends State<ChatterLogin> {
  String? email;
  String? password;
  bool loggingin = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      barrierEnabled: loggingin,
      child: Scaffold(
        // backgroundColor: Colors.transparent,
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
                    hintText: 'Email',
                    leading: Icons.mail,
                    obscure: false,
                    keyboard: TextInputType.emailAddress,
                    userTyped: (val) {
                      email = val;
                    },
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  CustomTextInput(
                    hintText: 'Password',
                    leading: Icons.lock,
                    obscure: true,
                    userTyped: (val) {
                      password = val;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Hero(
                      tag: 'loginbutton',
                      child: CustomButton(
                          text: 'login',
                          accentColor: Colors.white,
                          mainColor: Colors.deepPurple,
                          onpress: () async {
                            if (password != null && email != null) {
                              setState(() {
                                loggingin = true;
                              });
                              try {
                                final loggedUser =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email!, password: password!);
                                if (loggedUser != null) {
                                  setState(() {
                                    loggingin = false;
                                  });
                                  Navigator.of(context).pushNamed('/chat');
                                }
                              } catch (e) {
                                setState(() {
                                  loggingin = false;
                                });
                                Fluttertoast.showToast(
                                  msg: 'Login Failed: ${e.toString()}',
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
                                msg:
                                    'Uh oh! Please enter the email and password.',
                                toastLength: Toast
                                    .LENGTH_LONG, // Use Toast.LENGTH_LONG for longer duration
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb:
                                    3, // Set the duration for iOS and web
                                backgroundColor: Colors.deepPurple[900],
                                textColor: Colors.white,
                              );
                              // Navigator.pushReplacementNamed(context, '/chat');
                            }
                          })),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: const Text(
                        'or create an account',
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
