import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_raho/chat_assistant/chat_screen.dart';
import 'package:fit_raho/profile/profile_screen.dart';
import 'package:fit_raho/providers/firebase_auth_methods.dart';
import 'package:fit_raho/screens/disease_prediction/prediction_screen.dart';
import 'package:fit_raho/screens/home/home_screen.dart';
import 'package:fit_raho/screens/registration/register_screen.dart';
import 'package:fit_raho/screens/registration/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'design_course/home_design_course.dart';
import 'firebase_options.dart';
import 'fitness_app/fitness_app_home_screen.dart';
import 'hotel_booking/hotel_home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // force portrait mode
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(const MyApp()));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: AuthWrapper(),
          // FitnessAppHomeScreen(),
        // home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: SpinKitFadingCube(
                  color: Color(0xFFBA68C8),
                  size: 60.0,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
                body: Center(child: Text('Error fetching user data')));
          } else if (snapshot.hasData && snapshot.data!.exists) {
            // User document exists, show HomeScreen
            return FitnessAppHomeScreen();
          } else {
            // User document doesn't exist, show RegisterScreen
            return const RegisterScreen();
          }
        },
      );
    } else {
      return const WelcomePage();
    }
  }
}
