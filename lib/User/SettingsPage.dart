import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/User/ConfirmPasswordPage.dart';
import 'package:esi_sba_lost_object/User/DeleteAccountPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Auth/logingScreen.dart';
import '../Home/HomePage.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          title: Text('SETTINGS',
              style: GoogleFonts.ubuntu(fontSize: 17, color: Colors.white)),
          leading: BackButton(
            onPressed: () {
              Get.to(HomePage());
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("img/settings.json", height: 250),
                Material(
                  child: InkWell(
                    onTap: () {
                      Get.to(ConfirmPasswordPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.lock,
                              size: 25,
                              color: Colors.grey[850],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              "Change password",
                              style: TextStyle(
                                  color: Colors.grey[850], fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.notification_important_sharp,
                              size: 25,
                              color: Colors.grey[850],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Enable Notifications",
                              style: TextStyle(
                                  color: Colors.grey[850], fontSize: 17),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Switch(
                              value: notification!,
                              activeColor: Colors.blue,
                              onChanged: (val) async {
                                await FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "notification": val,
                                });
                                setState(() {
                                  notification = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          titleStyle: const TextStyle(color: Colors.red),
                          title: "WARNING",
                          middleText:
                              "Completing this action will delete all your personal data including your posts !!",
                          backgroundColor: Colors.white,
                          textConfirm: "Confirm",
                          textCancel: "Cancel",
                          cancelTextColor: Colors.black,
                          confirmTextColor: Colors.red,
                          buttonColor: Colors.grey[300],
                          barrierDismissible: false,
                          radius: 50,
                          onConfirm: () async {
                            Get.back();
                            Get.defaultDialog(
                                titleStyle: const TextStyle(color: Colors.red),
                                title: "CONFIRMATION",
                                middleText: "I am aware of what i am doing",
                                backgroundColor: Colors.white,
                                textConfirm: "Yes",
                                textCancel: "No",
                                cancelTextColor: Colors.black,
                                confirmTextColor: Colors.red,
                                buttonColor: Colors.grey[300],
                                barrierDismissible: false,
                                radius: 50,
                                onConfirm: () async {
                                  Get.back();

                                  Get.to(DeleteAccountPage());
                                });
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Icon(
                              Icons.remove_circle,
                              size: 25,
                              color: Colors.red,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              "Delete account",
                              style: TextStyle(color: Colors.red, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                          title: "Confirmation",
                          middleText: "Are you sure you want to log out ?",
                          backgroundColor: Colors.white,
                          textConfirm: "Confirm",
                          textCancel: "Cancel",
                          cancelTextColor: Colors.black,
                          confirmTextColor: Colors.black,
                          buttonColor: Colors.grey[300],
                          barrierDismissible: false,
                          radius: 50,
                          onConfirm: () async {
                            Get.back();
                            Get.defaultDialog(
                              confirm: const CircularProgressIndicator(),
                              title: "Signing out",
                              middleText: "please wait ...",
                              backgroundColor: Colors.white,
                              barrierDismissible: false,
                              radius: 20,
                            );
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .update({
                              "notification": false,
                            });
                            await FirebaseAuth.instance.signOut();

                            Get.offAll(loginScreen());
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      side: const BorderSide(
                          width: 1.5, color: Colors.deepPurple),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Center(
                          child: Text(
                        "Sign out",
                        style: TextStyle(
                            letterSpacing: 5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }

  void toggleSwitch(bool value) async {
    if (notification == false) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        "notification": true,
        "token": await FirebaseMessaging.instance.getToken(),
      });

      setState(() {
        notification = true;
      });
    } else {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        "notification": false,
        "token": await FirebaseMessaging.instance.getToken(),
      });
      setState(() {
        notification = false;
      });
    }
  }
}
