import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/firebase_auth_methods.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('temp login Screen'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton.large(
                        onPressed: () {
                          context
                              .read<FirebaseAuthMethods>()
                              .signInWithGoogle(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.g_translate),
                            Text('Sign in with Google'),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }
}
