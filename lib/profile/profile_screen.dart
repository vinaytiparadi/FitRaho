import 'package:fit_raho/profile/profile_parameters.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
            size: 30,
            color: Colors.black),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // shadowColor: Colors.transparent,
        title: Text(
          'profile'.toUpperCase(),
          style: GoogleFonts.raleway(
              color: Colors.black,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFF9A6BE5),
              ],
            )),
        child: Column(children: [
          const SizedBox(height: 10),
          Container(
            height: 230,
            width: 230,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                border: Border.all(
                    color: Colors.white, width: 10),
                boxShadow: const [
                  (BoxShadow(
                    color: Color.fromARGB(41, 0, 0, 0),
                    blurRadius: 10.0,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                  ))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/profile.png'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ruchika Suryawanshi'.toUpperCase(),
            style: GoogleFonts.raleway(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 340,
            height: 430,
            child: SingleChildScrollView(
              child: Column(children: const [
                Parameter(imgUrl: 'assets/bmi.png', magnitude: 25, scale: 'BMI', unit: 'kg/m2'),
                Parameter(imgUrl: 'assets/weight.png', magnitude: 67, scale: 'WEIGHT', unit: 'kg'),
                Parameter(imgUrl: 'assets/height.png', magnitude: 176, scale: 'HEIGHT', unit: 'cm'),
                Parameter(imgUrl: 'assets/age.png', magnitude: 20, scale: 'AGE', unit: 'yrs old'),
                const SizedBox(height: 75,)
              ]),
            ),
          )
        ]),
      ),
    );
  }
}