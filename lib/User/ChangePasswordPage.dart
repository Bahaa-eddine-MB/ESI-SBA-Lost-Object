import 'package:esi_sba_lost_object/Home/HomePage.dart';
import 'package:esi_sba_lost_object/User/ConfirmPasswordPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

bool visible = true;
bool visible2 = true;
String? newpassword;
String? confirmpassword;

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.off(ConfirmPasswordPage());
          },
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey[300],
      body: WillPopScope(
        onWillPop: ()async{
          return false;
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Lottie.asset("img/password-animation.json", height: 250),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Enter your new password',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: HexColor("#001d4f"))),
                ),
                const SizedBox(
                  height: 50,
                ),
                StatefulBuilder(
                  builder: (context, setState) => Padding(
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
                              newpassword = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a password";
                              }
                              if (val.length < 8) {
                                return "password can't be less than 8 characters";
                              }
                              return null;
                            },
                            obscureText: visible,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "New password",
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
                ),
                const SizedBox(
                  height: 20,
                ),
                StatefulBuilder(
                  builder: (context, setState) => Padding(
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
                              confirmpassword = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (val != newpassword) {
                                return "Wrong confirmation";
                              }
                              return null;
                            },
                            obscureText: visible2,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Confirm Password",
                                icon: const Icon(Icons.task_alt,
                                    color: Colors.deepPurple),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      visible2 = !visible2;
                                    });
                                  },
                                  child: Icon(
                                    visible2
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.deepPurple,
                                  ),
                                )),
                          ),
                        )),
                  ),
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
                          title: "Changing your password",
                          middleText: "please wait ...",
                          backgroundColor: Colors.white,
                          barrierDismissible: false,
                          radius: 20,
                        );
                        var hasconnection =
                            await InternetConnectionChecker().hasConnection;
                        if (hasconnection == true) {
        
      
                          final user = await FirebaseAuth.instance.currentUser;
                       AuthCredential cred = 
                            EmailAuthProvider.credential(
                              email: email!,
                              password: password!,
                            );
                          
                          await user!
                              .reauthenticateWithCredential(cred)
                              .then((value) {
                            user.updatePassword(newpassword!).then((_){
                                   Get.back();
                    Get.snackbar(
                            "Success",
                            "Your password has been updated successfully!.",
                            icon: const Icon(Icons.task, color: Colors.white),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            borderRadius: 20,
                            margin: const EdgeInsets.all(15),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            forwardAnimationCurve: Curves.easeOutBack,
                          );                  
                                Get.offAll(HomePage());
      
                              //Success, do something
                            }).catchError((error) {
                              print("noo");
      
                              //Error, show something
                            });
                          }).catchError((err) {
                            Get.back();
                            print(err.toString());
                            print("hell naaaah");
                          });
                     
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      child: const Center(
                          child: Text(
                        "Change password",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
