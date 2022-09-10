import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'ConfirmEmailPage.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  String? firstname, lastname, email, password, confirmpassword;
  bool visible1 = true;
  bool visible2 = true;
  bool isSwitched = false;
  bool pop = true;
  var option = 'Gallery';
  File? img;
  String? Urldownload = "";
  CroppedFile? _croppedFile;
  @override
  Widget build(BuildContext context) {
    void toggleSwitch(bool value) {
      if (isSwitched == false) {
        setState(() {
          isSwitched = true;
          option = 'Camera';
        });

        print('Switch Button is ON');
      } else {
        setState(() {
          isSwitched = false;
          option = 'Galerry';
        });
        print('Switch Button is OFF');
      }
    }

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
                    height: 20,
                  ),
                  Image.asset(
                    "img/Logo Light ESI-SBA 175.png",
                    height: 80,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Welcome to our humble application!',
                      style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: HexColor("#001d4f"))),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        img == null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 22, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.grey.shade300,
                                ),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.file(
                                    img!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _cropImage();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    fixedSize: const Size(120, 55),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  child: const Center(
                                      child: Text(
                                    "Picture",
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
                            Transform.scale(
                                scale: 1.5,
                                child: Switch(
                                  onChanged: toggleSwitch,
                                  value: isSwitched,
                                  activeColor: Colors.deepPurple,
                                  activeTrackColor: Colors.deepPurple,
                                  inactiveThumbColor: Colors.deepPurple,
                                  inactiveTrackColor: Colors.deepPurple,
                                )),
                            Text(
                              '$option',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
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
                              firstname = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your first name";
                              }
                              if (val.trim().length < 3) {
                                return "First name can't be less than 3 characters";
                              }
                              return null;
                            },
                            //  keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "First Name",
                                icon: Icon(
                                  Icons.person_outline,
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
                              lastname = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your last name";
                              }
                              if (val.trim().length < 2) {
                                return "Last name can't be less than 2 characters";
                              }
                              return null;
                            },
                            //  keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last Name",
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
                              email = val;
                            },
                            validator: (val) {
                              if ((val!.trim().isEmpty) ||
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
                                  Icons.email_outlined,
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
                                return "Please enter a password";
                              }
                              if (val.length < 8) {
                                return "password can't be less than 8 characters";
                              }
                              return null;
                            },
                            obscureText: visible1,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                icon: const Icon(Icons.lock,
                                    color: Colors.deepPurple),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      visible1 = !visible1;
                                    });
                                  },
                                  child: Icon(
                                    visible1
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
                              confirmpassword = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (val != password) {
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
                                )
                                //Icon(Icons.visibility,color: Colors.deepPurple,)
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
                                setState(() {
                                  pop = false;
                                });
                                Get.defaultDialog(
                                  confirm: const CircularProgressIndicator(),
                                  title: "Loading",
                                  middleText: "please wait ...",
                                  backgroundColor: Colors.white,
                                  barrierDismissible: false,
                                  radius: 20,
                                );
                                var hasconnection =
                                    await InternetConnectionChecker()
                                        .hasConnection;
                                if (hasconnection == true) {
                                  try {
                                    await uploadFile();

                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: email!,
                                                password: password!);
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .set({
                                      "notification": true,
                                      "token": await FirebaseMessaging.instance
                                          .getToken(),
                                      "owner": FirebaseAuth
                                          .instance.currentUser?.uid,
                                      "email": email!.trim(),
                                      "firstname": firstname!.trim(),
                                      "lastname": lastname!.trim(),
                                      "phone": "",
                                      "picture": Urldownload,
                                      "about": "",
                                      "join": DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now()),
                                    });
                                    setState(() {
                                      pop = true;
                                    });
                                    Get.back();
                                    Get.off(ConfirmEmailPage());
                                  } on FirebaseAuthException catch (e) {
                                    Get.back();
                                    setState(() {
                                      pop = true;
                                    });
                                    if (e.code == 'weak-password') {
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                              'The password provided is too weak.'),
                                          actions: [
                                            TextButton(
                                              child: const Text("Close"),
                                              onPressed: () => Get.back(),
                                            ),
                                          ],
                                        ),
                                      );
                                      print(
                                          'The password provided is too weak.');
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                              'The account already exists for that email.'),
                                          actions: [
                                            TextButton(
                                              child: const Text("Close"),
                                              onPressed: () => Get.back(),
                                            ),
                                          ],
                                        ),
                                      );
                                      print(
                                          'The account already exists for that email.');
                                    } else {
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
                                  } catch (e) {
                                    Get.back();
                                    setState(() {
                                      pop = true;
                                    });
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Error'),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                            child: const Text("Close"),
                                            onPressed: () => Get.back(),
                                          ),
                                        ],
                                      ),
                                    );
                                    print(e);
                                  }
                                } else {
                                  setState(() {
                                    pop = true;
                                  });
                                  Get.back();
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
                              });
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
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<CroppedFile?> _cropImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: !isSwitched ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        img = File(pickedFile.path);
      });
    }
    if (img != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: img!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
          img = File(croppedFile.path);
        });
      }
    }
  }

  void _clear() {
    setState(() {
      img = null;
      _croppedFile = null;
    });
  }

  Future uploadFile() async {
    if (img == null) {
    } else {
      File file = File(img!.path);
      var refStorage = FirebaseStorage.instance.ref("images/${img!}.jpg");
      await refStorage.putFile(file);
      var url = await refStorage.getDownloadURL();

      Urldownload = url;
    }
  }
}
