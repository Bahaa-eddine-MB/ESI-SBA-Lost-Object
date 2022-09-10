import 'dart:async';
import 'package:esi_sba_lost_object/Auth/logingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'PhoneNumberPage.dart';

class ConfirmEmailPage extends StatefulWidget {
  ConfirmEmailPage({Key? key}) : super(key: key);

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
    }
     timer= Timer.periodic(const Duration(seconds: 3), (_)=>checkEmailVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  
  Future checkEmailVerified()async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified= FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) {timer?.cancel();
      Get.offAll(PhoneNumberPage());
    };
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    }on FirebaseException catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(e.message.toString()),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('EMAIL VERIFICATION',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: HexColor("#001d4f"))),
          ),
          Lottie.asset("img/72126-email-verification.json", height: 250),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('A verification email has been sent to your email',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: HexColor("#001d4f"))),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('If you dont get the email check the spam section',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    fontSize: 12,
                    color: HexColor("#001d4f"))),
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(
              onPressed: () {
               canResendEmail ? sendVerificationEmail() :  Get.dialog(
                            AlertDialog(
                              title: const Text('Alert'),
                              content: const Text("Email already sent !"),
                              actions: [
                                TextButton(
                                  child: const Text("Close"),
                                  onPressed: () => Get.back(),
                                ),
                              ],
                            ),
                          ); 
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
                  "Resend",
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
          const SizedBox(height: 10,),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: TextButton(
              onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(loginScreen());
              },
           
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Center(
                    child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
            
              ),
            ),
          ),
        ],
      )),
    );
  }
}
