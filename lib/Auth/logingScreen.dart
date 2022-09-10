import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import 'RegistrationPage.dart';
import 'SplashScreen.dart';
import 'forgtPasswordPage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class loginScreen extends StatefulWidget {
  loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final formKey = GlobalKey<FormState>();
  bool visible = true;
  var size, h, w;
  bool? hasconnection;
  String? password, email;
  bool pop = true;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: WillPopScope(
        onWillPop: () async {
          return pop;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Image.asset(
                    "img/Logo Light ESI-SBA 175.png",
                    height: 150,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Find your lost object !',
                      style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: HexColor("#001d4f"))),
                  const SizedBox(
                    height: 60,
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
                              email = val;
                            },
                            validator: (val) {
                              if ((val!.isEmpty) ||
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.deepPurple,
                                )),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
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
                              password = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            obscureText: visible,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                icon: const Icon(Icons.lock,
                                    color: Colors.deepPurple),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      visible = !visible;
                                    });
                                  },
                                  child: Icon(
                                    visible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.deepPurple,
                                  ),
                                )
                                //Icon(Icons.visibility,color: Colors.deepPurple,)
                                ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
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
                          hasconnection =
                              await InternetConnectionChecker().hasConnection;

                          if (hasconnection == true) {
                            setState(() {
                              pop = false;
                            });

                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                      email: email!.trim(),
                                      password: password!);
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .update({
                                "notification": true,
                                "token":
                                    await FirebaseMessaging.instance.getToken(),
                              });
                              Get.back();
                              setState(() {
                                pop = true;
                              });
                              Get.off(SplashScreen());
                            } on FirebaseAuthException catch (e) {
                              Get.back();
                              setState(() {
                                pop = true;
                              });
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
                                        'Wrong password provided for that user.'),
                                    actions: [
                                      TextButton(
                                        child: const Text("Close"),
                                        onPressed: () => Get.back(),
                                      ),
                                    ],
                                  ),
                                );
                                print('Wrong password provided for that user.');
                              }
                            }
                          } else {
                            setState(() {
                              pop = true;
                            });
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
                            // Get.dialog(
                            //   AlertDialog(
                            //     backgroundColor: Colors.red,
                            //     titleTextStyle:
                            //         const TextStyle(color: Colors.white),
                            //     title: const Text('Error'),
                            //     content: const Text(
                            //       'No internet connection.',
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //     actions: [
                            //       TextButton(
                            //         child: const Text(
                            //           "Close",
                            //           style: TextStyle(color: Colors.white),
                            //         ),
                            //         onPressed: () => Get.back(),
                            //       ),
                            //     ],
                            //   ),
                            // );
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
                          "Sign in",
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
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.5),
                    child: TextButton(
                      onPressed: () {
                        Get.to(forgetPasswordPage(reset: true,));
                      },
                      child: const Text(
                        "Forgot your password ?",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member?"),
                      TextButton(
                        onPressed: () {
                          Get.to(RegistrationPage());
                        },
                        child: const Text(
                          "Register now!",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
