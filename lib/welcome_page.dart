import 'package:flutter/material.dart';

class WelcomeSignUp extends StatefulWidget {
  const WelcomeSignUp({Key? key}) : super(key: key);

  @override
  _WelcomeSignUpState createState() => _WelcomeSignUpState();
}

class _WelcomeSignUpState extends State<WelcomeSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              image: AssetImage('assets/images/Rectangle5.png'),
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.6,
                              // colorBlendMode: ,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 45),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 165,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x00ffffff),
                                    Color(0x0cffffff),
                                    Colors.white
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Positioned(
                          bottom: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "FitRaho",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "By creating an account you get access to an \n"
                                "unlimited number of exercises and plans",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GoogleButton(text: "Sign up with Google", onPressed: () => {}),
                GoogleButton(
                  text: "Sign in with Google",
                  onPressed: () => {},
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => {},
                          child: Text(
                            "Start your journey now..",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // loading ? Center(child: CircularProgressIndicator()) : Container(),
          ],
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 15,
        ),
        child: OutlinedButton.icon(
          icon: Image(
            image: AssetImage("assets/images/google.png"),
          ),
          onPressed: onPressed,
          label: Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            )),
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.black, width: 1)),
          ),
        ),
      ),
    );
  }
}
