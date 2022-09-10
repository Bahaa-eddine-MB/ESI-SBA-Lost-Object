import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'logingScreen.dart';

class forgetPasswordPage extends StatefulWidget {
  bool reset;
  forgetPasswordPage({Key? key,required this.reset}) : super(key: key);

  @override
  State<forgetPasswordPage> createState() => _forgetPasswordPageState();
}
    String? email;

class _forgetPasswordPageState extends State<forgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Lottie.asset("img/75988-forgot-password.json", height: 250),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    'Enter your email and we will send you a password reset link',
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
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () {
                    formKey.currentState?.save();
                    if (formKey.currentState!.validate()) {
                      verifyEmail();
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
                      "Reset Password",
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
           widget.reset ==true ?   TextButton(
                onPressed: () {
                  Get.to(loginScreen());
                },
                child: const Text(
                  "Sign-in",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ): const SizedBox(height: 0,)
            ],
          ),
        ),
      )),
    );
  }

  Future verifyEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!.trim());
      Get.snackbar(
        "Password Reset",
        "Email has been sent successfully",
        icon: const Icon(Icons.email_rounded, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepPurple,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } on FirebaseException catch (e) {
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
}
