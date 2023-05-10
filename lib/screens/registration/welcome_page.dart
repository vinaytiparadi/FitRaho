import 'package:fit_raho/providers/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
                              image: const AssetImage('assets/images/Rectangle5.png'),
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.6,
                              // colorBlendMode: ,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(bottom: 45),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 165,
                              decoration: const BoxDecoration(
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
                          bottom: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
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
                                "unlimited number of exercises and plans.",
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
                const SizedBox(height: 10),
                GoogleButton(
                  text: "Sign in with Google",
                  onPressed: () => {
                  context
                      .read<FirebaseAuthMethods>()
                      .signInWithGoogle(context)
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => {},
                          child: const Text(
                            "Start your journey now..",
                            style: TextStyle(color: Colors.grey, fontSize: 17),
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
            image: const AssetImage("assets/images/google.png"),
          ),
          onPressed: onPressed,
          label: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            )),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.black, width: 1)),
          ),
        ),
      ),
    );
  }
}
