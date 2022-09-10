import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/User/ChangePasswordPage.dart';
import 'package:esi_sba_lost_object/User/SettingsPage.dart';
import 'package:esi_sba_lost_object/User/appBarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

import '../Auth/forgtPasswordPage.dart';
String? email="";    
String? password;

class ConfirmPasswordPage extends StatefulWidget {
  ConfirmPasswordPage({Key? key}) : super(key: key);

  @override
  State<ConfirmPasswordPage> createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var doc = FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    return FutureBuilder<QuerySnapshot>(
      future: doc.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
    leading: BackButton(
      onPressed: (){
      Get.to(SettingsPage());
      },
      color: Colors.black,
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    // actions: [
    //   IconButton(
    //   onPressed: (){}, 
    //   icon:Icon(my_icon,color: Colors.black,) ),
       
    // ],
  ),
            backgroundColor: Colors.grey[300],
            body: SafeArea(
                child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Lottie.asset("img/change-passwords.json", height: 250),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Enter your old password to continue',
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
                              obscureText: true,
                              onSaved: (val) {
                                password = val;
                              },
                              validator: (val) {
                                if ((val!.isEmpty)) {
                                  return "Enter your password";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Old password",
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                        onPressed: () async {
                          formKey.currentState?.save();
                          if (formKey.currentState!.validate()) {
                            Get.defaultDialog(
                              confirm: const CircularProgressIndicator(),
                              title: "Loading",
                              middleText: "please wait ...",
                              backgroundColor: Colors.white,
                              barrierDismissible: false,
                              radius: 20,
                            );
                            var hasconnection =
                                await InternetConnectionChecker().hasConnection;

                            if (hasconnection == true) {
                              try {
                                email =snapshot.data!.docs[0]
                                                ["email"]; 
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: snapshot.data!.docs[0]
                                                ["email"],
                                            password: password!);

                                Get.back();
                                Get.to(ChangePasswordPage());
                                // Get.off(SplashScreen());
                              } on FirebaseAuthException catch (e) {
                                Get.back();

                                if (e.code == 'user-not-found') {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'No user found for that email.'),
                                      actions: [
                                        TextButton(
                                          child: const Text("Close"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                                  print('No user found for that email.');
                                } else if (e.code == 'wrong-password') {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Wrong password provided.'),
                                      actions: [
                                        TextButton(
                                          child: const Text("Close"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                                  print(
                                      'Wrong password provided for that user.');
                                }
                              }
                            } else {
                              Get.back();
                              Get.snackbar(
                                "Error",
                                "No internet connection.",
                                icon: const Icon(Icons.portable_wifi_off,
                                    color: Colors.white),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                borderRadius: 20,
                                margin: const EdgeInsets.all(15),
                                colorText: Colors.white,
                                duration: const Duration(seconds: 3),
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                            //      fixedSize: const Size(300, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          child: const Center(
                              child: Text(
                            "Confirm Password",
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
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(forgetPasswordPage(
                          reset: false,
                        ));
                      },
                      child: const Text(
                        "Forgot your password ?",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        }
        return const Scaffold(
          body:  Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          )),
        );
      },
    );
  }
}
