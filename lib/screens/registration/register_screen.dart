import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../fitness_app/fitness_app_home_screen.dart';
import '../../utils/utility_methods.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  List<String> genderList = ['Male', 'Female', 'Prefer not to say'];

  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  Object? gender;
  bool _isChecked = false;

  @override
  void dispose(){
    nameController.dispose();
    contactNumberController.dispose();
    heightController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[50],
        title: const Text('Register Now!'),
        centerTitle: true,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.18,
            image: AssetImage('assets/registration_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              border: Utils.outlineEnabledBorder(),
                              labelText: 'Full Name',
                              hintText: 'Enter Full Name'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: contactNumberController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              border: Utils.outlineEnabledBorder(),
                              labelText: 'Contact Number',
                              hintText: 'Enter Contact Number'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          // style: const TextStyle(fontSize: 16),
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              border: Utils.outlineEnabledBorder(),
                              labelText: 'Age',
                              hintText: 'Enter Age'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // style: const TextStyle(fontSize: 16),
                          controller: heightController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              border: Utils.outlineEnabledBorder(),
                              labelText: 'Height (in cm)',
                              hintText: 'Enter your Height'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // style: const TextStyle(fontSize: 16),
                          textCapitalization: TextCapitalization.words,

                          controller: weightController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              border: Utils.outlineEnabledBorder(),
                              labelText: 'Weight (in kg)',
                              hintText: 'Enter your Weight'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.4),
                              )

                          ),
                          child: DropdownButton(
                            // menuMaxHeight: 100,
                            //itemHeight: 300.0,
                            hint: const Text(
                              'Select Gender',
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                            underline: const SizedBox(),
                            isExpanded: true,
                            iconEnabledColor: Colors.black,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: Colors.black),
                            focusColor: Colors.white,
                            value: gender,
                            items: genderList
                                .map<DropdownMenuItem<String>>((String valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: Text(
                                  valueItem,
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (_value) {
                              setState(() {
                                gender = _value;
                              });
                              log('$_value');
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                    CheckboxListTile(
                      title: const Text(
                          'I provide consent for saving personal data using DISHA protocol.'),
                      value: _isChecked, onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });},),

                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: Utils.scHeight(context)*0.06,
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () async {

                              if(_isChecked ==true){
                                const snackBar = SnackBar(
                                  duration: Duration(milliseconds: 800),
                                  backgroundColor: Colors.green,
                                  content: Text('Registering user..'),
                                );

                                User user = FirebaseAuth.instance.currentUser!;

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .set({
                                  'name': nameController.text,
                                  'contact_number': contactNumberController.text,
                                  'age': ageController.text,
                                  'height': heightController.text,
                                  'weight': weightController.text,
                                  'gender': gender,
                                });

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (builder) => FitnessAppHomeScreen()),
                                      (route) => false,
                                );
                              }


                            }, child: Text("Register"),),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
