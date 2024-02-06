import 'package:chat_app/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatterHome extends StatefulWidget {
  @override
  _ChatterHomeState createState() => _ChatterHomeState();
}

class _ChatterHomeState extends State<ChatterHome>
    with TickerProviderStateMixin {
  late AnimationController mainController;
  Animation? mainAnimation;
  @override
  void initState() {
    super.initState();
    mainController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    mainAnimation =
        ColorTween(begin: Colors.deepPurple[900], end: Colors.grey[100])
            .animate(mainController)
            ..addListener(() {
              setState(() {});
            });
        mainController.forward();
  }
  @override
  void dispose() {
    mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAnimation?.value ?? Colors.transparent,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'heroicon',
                  child: Icon(
                    Icons.textsms,
                    size: mainController.value * 100,
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
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "World's most private chatting app".toUpperCase(),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.deepPurple,
                      ),
                      speed: const Duration(milliseconds: 60),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Hero(
                  tag: 'loginbutton',
                  child: CustomButton(
                    text: 'Login',
                    accentColor: Colors.deepPurple,
                    mainColor: Colors.white,
                    onpress: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Hero(
                  tag: 'signupbutton',
                  child: CustomButton(
                    text: 'Signup',
                    accentColor: Colors.white,
                    mainColor: Colors.deepPurple,
                    onpress: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const Text('Made with ♥ by ishandeveloper')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
