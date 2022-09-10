import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/User/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'appBarWidget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? firstname, lastname, about, email, phone, picture;

  File? img;
  CroppedFile? _croppedFile;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getData();
  // }

  // getData() async {
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       event.docs.forEach((element) {
  //         firstname = element.data()["firstname"];
  //       });
  //     });
  //   });
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       event.docs.forEach((element) {
  //         lastname = element.data()["lastname"];
  //       });
  //     });
  //   });
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       event.docs.forEach((element) {
  //         email = element.data()["email"];
  //       });
  //     });
  //   });
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       event.docs.forEach((element) {
  //         phone = element.data()["phone"];
  //       });
  //     });
  //   });
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       event.docs.forEach((element) {
  //         picture = element.data()["picture"];
  //       });
  //     });
  //   });
  //    await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       event.docs.forEach((element) {
  //         about = element.data()["about"];
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var doc = FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Get.to(ProfilePage());
            },
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: WillPopScope(
          onWillPop: ()async{
             return false;
          },
          child: FutureBuilder<QuerySnapshot>(
            future: doc.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Center(
                        child: Stack(children: [
                          buildImage("${snapshot.data!.docs[0]['picture']}"),
                          Positioned(
                              bottom: 0,
                              right: 4,
                              child: buildEditIcon(Colors.deepPurple))
                        ]),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "First Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              firstname = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "This field cannot be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Edit your first name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            controller: TextEditingController(
                                text: "${snapshot.data!.docs[0]['firstname']}"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Last Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              lastname = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "This field cannot be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Edit your last name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            controller: TextEditingController(
                                text: "${snapshot.data!.docs[0]['lastname']}"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Phone number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              phone = val;
                            },
                            validator: (val) {
                              if (val!.isNotEmpty &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              if (val.isNotEmpty && val.length != 10) {
                                return "Phone Number should be in 10 digits";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Add a phone number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            controller: TextEditingController(
                                text: "${snapshot.data!.docs[0]['phone']}"),
                            keyboardType: TextInputType.phone,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "About",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              about = val;
                            },
                            validator: (val) {
                              return null;
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Add something about yourself !",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            controller: TextEditingController(
                                text: "${snapshot.data!.docs[0]['about']}"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: ElevatedButton(
                          onPressed: () async {
                            formKey.currentState?.save();
                            if (formKey.currentState!.validate()) {
                              Get.defaultDialog(
                                  title: "Confirmation",
                                  middleText: "Are you sure about the changes ?",
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
                                    if (img != null) {
                                      uploadFile();
                                    }
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .update({
                                      "phone": phone,
                                      "firstname": firstname!.trim(),
                                      "about": about!.trim(),
                                      "lastname": lastname!.trim(),
                                    });
        
                                    Get.back();
                                    Get.back();
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Alert'),
                                        content: const Text(
                                            'Your informations have been updated successfully.'),
                                        actions: [
                                          TextButton(
                                            child: const Text("Close"),
                                            onPressed: () => Get.back(),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: const Center(
                                child: Text(
                              "Confirm changes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            },
          ),
        ));
  }

  Future<CroppedFile?> _cropImage(bool isGallery) async {
    final pickedFile = await ImagePicker().pickImage(
        source: isGallery == true ? ImageSource.gallery : ImageSource.camera);
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

  Widget buildImage(String input) {
    if (img == null) {
      return ClipOval(
        child: input != ""
            ? Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: NetworkImage(input),
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: "Choose diractory",
                          backgroundColor: Colors.white,
                          titleStyle: const TextStyle(color: Colors.black),
                          middleTextStyle: const TextStyle(color: Colors.white),
                          textCancel: "Cancel",
                          cancelTextColor: Colors.black,
                          buttonColor: Colors.black,
                          barrierDismissible: false,
                          radius: 50,
                          content: Column(children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                _cropImage(false);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: Icon(
                                        Icons.camera,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Camera",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                _cropImage(true);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: Icon(
                                        Icons.image,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Gallery",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]));
                    },
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: "Choose diractory",
                      backgroundColor: Colors.white,
                      titleStyle: const TextStyle(color: Colors.black),
                      middleTextStyle: const TextStyle(color: Colors.white),
                      textCancel: "Cancel",
                      cancelTextColor: Colors.black,
                      buttonColor: Colors.black,
                      barrierDismissible: false,
                      radius: 50,
                      content: Column(children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _cropImage(false);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Icon(
                                    Icons.camera,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Camera",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _cropImage(true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Icon(
                                    Icons.image,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Gallery",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 25, color: Colors.white),
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
                )),
      );
    } else {
      return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: FileImage(img!),
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            child: InkWell(
              onTap: () {
                Get.defaultDialog(
                    title: "Choose diractory",
                    backgroundColor: Colors.white,
                    titleStyle: const TextStyle(color: Colors.black),
                    middleTextStyle: const TextStyle(color: Colors.white),
                    textCancel: "Cancel",
                    cancelTextColor: Colors.black,
                    buttonColor: Colors.black,
                    barrierDismissible: false,
                    radius: 50,
                    content: Column(children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _cropImage(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Icon(
                                  Icons.camera,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Camera",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _cropImage(true);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Icon(
                                  Icons.image,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Gallery",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]));
              },
            ),
          ),
        ),
      );
    }
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
            color: color,
            all: 8,
            child: const Icon(
              Icons.add_a_photo,
              size: 20,
              color: Colors.white,
            )),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          child: child,
          color: color,
        ),
      );

  Future uploadFile() async {
    File file = File(img!.path);
    var refStorage = FirebaseStorage.instance.ref("images/${img!}.jpg");
    await refStorage.putFile(file);
    var url = await refStorage.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "picture": url,
    });
  }
}
