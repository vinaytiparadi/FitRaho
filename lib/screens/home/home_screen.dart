import 'package:fit_raho/providers/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
        appBar: AppBar(title: Text('Home Screen'),centerTitle: true,),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // when user signs anonymously or with phone, there is no email
            if (!user.isAnonymous && user.phoneNumber == null) Text(user.email!),
            if (!user.isAnonymous && user.phoneNumber == null)
              Text(user.providerData[0].providerId),
            // display phone number only when user's phone number is not null
            if (user.phoneNumber != null) Text(user.phoneNumber!),
            // uid is always available for every sign in method
            Text(user.uid),
            // display the button only when the user email is not verified
            // or isnt an anonymous user

            ElevatedButton(
              onPressed: () {
                context.read<FirebaseAuthMethods>().signOut(context);
              },
              child: Text('Sign Out'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<FirebaseAuthMethods>().deleteAccount(context);
              },
              child: Text('Delete Account'),
            ),
          ],
        )
    );
  }
}
