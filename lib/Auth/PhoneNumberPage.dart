import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'SplashScreen.dart';

var size, h, w;

class PhoneNumberPage extends StatefulWidget {
  PhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  @override
  Widget build(BuildContext context) {
    //size = MediaQuery.of(context).size;
    // h = size.height;
    // w = size.width;
    String? phone;
    final Key = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: Key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Lottie.asset("img/86837-contact-number-icon.json",
                      height: 250),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Add your phone number',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: HexColor("#001d4f"))),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            onSaved: (val) {
                              phone = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your phone number";
                              }
                              if (!RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              if (val.trim().length != 10) {
                                return "Phone Number should be in 10 digits";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone Number",
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.deepPurple,
                                )),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  
                       ElevatedButton.icon(
                          icon: const Icon(Icons.add_call),
                          onPressed: () async {
                            Key.currentState?.save();
                            if (Key.currentState!.validate()) {
                              Get.defaultDialog(
                                  title: "Confirmation",
                                  middleText:
                                      "Are you sure about the informations ?",
                                  backgroundColor: Colors.white,
                                  textConfirm: "Confirm",
                                  textCancel: "Cancel",
                                  cancelTextColor: Colors.black,
                                  confirmTextColor: Colors.black,
                                  buttonColor: Colors.grey,
                                  barrierDismissible: false,
                                  radius: 50,
                                  onConfirm: () async {
                                     Get.defaultDialog(
                                        confirm:
                                            const CircularProgressIndicator(),
                                        title: "Loading",
                                        middleText: "please wait ...",
                                        backgroundColor: Colors.white,
                                        barrierDismissible: false,
                                        radius: 20,
                                      );

                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .update({
                                      "phone": phone,
                                    });
                                    Get.back();
                                    Get.offAll(SplashScreen());
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              //      fixedSize: const Size(300, 100),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          label: Container(
                            padding: const EdgeInsets.all(18),
                            child: const Center(
                                child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                          ),
                    
                      ),
                      const SizedBox(width: 20,),
                     ElevatedButton.icon(
                          onPressed: () {
                            Get.to(SplashScreen());
                          },
                          icon: const Icon(Icons.arrow_forward),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              //      fixedSize: const Size(300, 100),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          label: Container(
                            padding: const EdgeInsets.all(18),
                            child: const Center(
                                child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                            // decoration: BoxDecoration(
                            //     color: Colors.deepPurple,
                            //     borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                  
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
