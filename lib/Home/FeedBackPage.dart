import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class FeedBackPage extends StatefulWidget {
  FeedBackPage({Key? key}) : super(key: key);

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
  bool value5 = false;
  String val1 = "", val2 = "", val3 = "", val4 = "", val5 = "";
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var doc = FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    String? feedback;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            formKey.currentState?.save();
            if (feedback != null && feedback!.trim() != "") {
              Get.defaultDialog(
                  title: "Confirmation",
                  middleText: "Do you wish to discard your feedback ?",
                  backgroundColor: Colors.white,
                  textConfirm: "Confirm",
                  textCancel: "Cancel",
                  cancelTextColor: Colors.black,
                  confirmTextColor: Colors.black,
                  buttonColor: Colors.grey,
                  barrierDismissible: false,
                  radius: 50,
                  onConfirm: () {
                    Get.back();
                    Get.back();
                  });
            } else {
              Get.back();
            }
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text('FEED BACK',
            style: GoogleFonts.ubuntu(fontSize: 17, color: Colors.white)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          formKey.currentState?.save();
          if (feedback != null && feedback!.trim() != "") {
            Get.defaultDialog(
                title: "Confirmation",
                middleText: "Do you wish to discard your feedback ?",
                backgroundColor: Colors.white,
                textConfirm: "Confirm",
                textCancel: "Cancel",
                cancelTextColor: Colors.black,
                confirmTextColor: Colors.black,
                buttonColor: Colors.grey,
                barrierDismissible: false,
                radius: 50,
                onConfirm: () {
                  Get.back();
                  Get.back();
                });
          }
          return true;
        },
        child: Form(
          key: formKey,
          child: FutureBuilder<QuerySnapshot>(
              future: doc.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Lottie.asset("img/feedback-animation.json",
                                height: 250),
                            const Text(
                              'Please select the type of the feedback :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            StatefulBuilder(
                              builder: (context, setState) => Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        value1 = !value1;
                                      });
                                    },
                                    leading: Checkbox(
                                      shape: const CircleBorder(),
                                      value: value1,
                                      onChanged: (value) {
                                        setState(() {
                                          value1 = value!;
                                        });
                                      },
                                    ),
                                    title: Text(
                                      "Loging trouble",
                                      style: TextStyle(
                                          color: value1
                                              ? Colors.deepPurple
                                              : Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        value2 = !value2;
                                      });
                                    },
                                    leading: Checkbox(
                                      shape: const CircleBorder(),
                                      value: value2,
                                      onChanged: (value) {
                                        setState(() {
                                          value2 = value!;
                                        });
                                      },
                                    ),
                                    title: Text(
                                      "Phone number related",
                                      style: TextStyle(
                                          color: value2
                                              ? Colors.deepPurple
                                              : Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        value3 = !value3;
                                      });
                                    },
                                    leading: Checkbox(
                                      value: value3,
                                      onChanged: (value) {
                                        setState(() {
                                          value3 = value!;
                                        });
                                      },
                                      shape: const CircleBorder(),
                                    ),
                                    title: Text(
                                      "Personal profile",
                                      style: TextStyle(
                                          color: value3
                                              ? Colors.deepPurple
                                              : Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        value4 = !value4;
                                      });
                                    },
                                    leading: Checkbox(
                                      value: value4,
                                      onChanged: (value) {
                                        setState(() {
                                          value4 = value!;
                                        });
                                      },
                                      shape: const CircleBorder(),
                                    ),
                                    title: Text(
                                      "Other issues",
                                      style: TextStyle(
                                          color: value4
                                              ? Colors.deepPurple
                                              : Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        value5 = !value5;
                                      });
                                    },
                                    leading: Checkbox(
                                      value: value5,
                                      onChanged: (value) {
                                        setState(() {
                                          value5 = value!;
                                        });
                                      },
                                      shape: const CircleBorder(),
                                    ),
                                    title: Text(
                                      "Suggestions",
                                      style: TextStyle(
                                          color: value5
                                              ? Colors.deepPurple
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return "This field cannot be empty";
                                }
                                return null;
                              },
                              onSaved: ((newValue) {
                                feedback = newValue;
                              }),
                              decoration: InputDecoration(
                                hintText: "Description",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: ElevatedButton(
                                onPressed: () async {
                                  formKey.currentState?.save();

                                  if (formKey.currentState!.validate()) {
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
                                            title: "Sending your feedback",
                                            middleText: "please wait ...",
                                            backgroundColor: Colors.white,
                                            barrierDismissible: false,
                                            radius: 20,
                                          );
                                          var hasconnection =
                                              await InternetConnectionChecker()
                                                  .hasConnection;
                                          if (hasconnection == true) {
                                            if (value1 == true)
                                              val1 = "Logging trouble";
                                            if (value2 == true)
                                              val2 = "Phone number related";
                                            if (value3 == true)
                                              val3 = "Personal profile";
                                            if (value4 == true)
                                              val4 = "Other issues";
                                            if (value5 == true)
                                              val5 = "Suggestions";

                                            print(val1 +
                                                val2 +
                                                val3 +
                                                val4 +
                                                val5);

                                            await sendEmail(
                                                name: snapshot.data!.docs[0]
                                                        ["firstname"] +
                                                    " " +
                                                    snapshot.data!.docs[0]
                                                        ["lastname"],
                                                message: val1 +
                                                    "  " +
                                                    val2 +
                                                    "  " +
                                                    val3 +
                                                    "  " +
                                                    val4 +
                                                    "  " +
                                                    val5,
                                                feed: feedback!,
                                                email: snapshot.data!.docs[0]
                                                    ["email"]);
                                            print("yeeeeeeeees");
                                            val1 = "";
                                            val2 = "";
                                            val3 = "";
                                            val4 = "";
                                            val5 = "";
                                            Get.back();
                                            Get.back();
                                            Get.snackbar(
                                              "Success",
                                              "Your feedback was sent successfully \nThank you for helping improving the app!.",
                                              icon: const Icon(Icons.task,
                                                  color: Colors.white),
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.green,
                                              borderRadius: 20,
                                              margin: const EdgeInsets.all(15),
                                              colorText: Colors.white,
                                              duration:
                                                  const Duration(seconds: 6),
                                              forwardAnimationCurve:
                                                  Curves.easeOutBack,
                                            );
                                          } else {
                                            Get.back();
                                            Get.back();
                                            Get.snackbar(
                                              "Error",
                                              "No internet connection.",
                                              icon: const Icon(
                                                  Icons.portable_wifi_off,
                                                  color: Colors.white),
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              borderRadius: 20,
                                              margin: const EdgeInsets.all(15),
                                              colorText: Colors.white,
                                              duration:
                                                  const Duration(seconds: 4),
                                              forwardAnimationCurve:
                                                  Curves.easeOutBack,
                                            );
                                          }
                                        });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: const Center(
                                      child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }),
        ),
      ),
    );
  }

  Future sendEmail(
      {required String name,
      required String message,
      required String feed,
      required String email})
      async {
           final serviceId = 'service_mqj2bwm';
           final templateId = 'template_k2udo0g';
           final userId = '4j3kuQxgTrdJ8vE3M';
           final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
           final response = await http.post(url,

        headers: {

          'origin': 'http//localhost',
          'Content-Type': 'application/json',

        },

        body: json.encode({

          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_feedback': feed,
            'user_name': name,
            'user_email': email,
            'user_message': message
          }
          
        }));
  }
}
