import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/Home/HomePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class EditPostPage extends StatefulWidget {
  String cont;
  String value, id;
  String img;
  EditPostPage(
      {Key? key,
      required this.cont,
      required this.id,
      required this.value,
      required this.img})
      : super(key: key);
  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

File? img, originalImg;
bool image = false;
CroppedFile? _croppedFile;
String urlDownload = "";

class _EditPostPageState extends State<EditPostPage> {
  List<String> items = ["Found Object", "Lost Object"];

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    String? description;
    return Form(
      key: formKey,
      child: Scaffold(
        floatingActionButton: img != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                child: FloatingActionButton(
                  onPressed: () {
                    _cropImage();
                    formKey.currentState?.save();
                    setState(() {
                      if (description != null) {
                        widget.cont = description!;
                      }
                    });
                  },
                  child: const Icon(
                    Icons.crop,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            : img == null || widget.img != ""
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    child: FloatingActionButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Choose diractory",
                            backgroundColor: Colors.white,
                            titleStyle: const TextStyle(color: Colors.black),
                            middleTextStyle:
                                const TextStyle(color: Colors.white),
                            textCancel: "Cancel",
                            cancelTextColor: Colors.black,
                            buttonColor: Colors.black,
                            barrierDismissible: false,
                            radius: 50,
                            content: Column(children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  _uploadImage(false);
                                  formKey.currentState?.save();
                                  setState(() {
                                    if (description != null) {
                                      widget.cont = description!;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
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
                                  _uploadImage(true);
                                  formKey.currentState?.save();
                                  setState(() {
                                    if (description != null) {
                                      widget.cont = description!;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
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
                        // _uploadImage();
                      },
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              formKey.currentState?.save();

              if (description != null && description != "") {
                Get.defaultDialog(
                    title: "Confirmation",
                    middleText: "Do you wish to discard the post ?",
                    backgroundColor: Colors.white,
                    textConfirm: "Confirm",
                    textCancel: "Cancel",
                    cancelTextColor: Colors.black,
                    confirmTextColor: Colors.black,
                    buttonColor: Colors.grey,
                    barrierDismissible: false,
                    radius: 50,
                    onConfirm: () {
                      _clear();
                      Get.to(HomePage());
                    });
              } else {
                _clear();
                Get.to(HomePage());
              }
            },
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: WillPopScope(
           onWillPop: ()async{

              if (description != null && description != "") {
                Get.defaultDialog(
                    title: "Confirmation",
                    middleText: "Do you wish to discard the post ?",
                    backgroundColor: Colors.white,
                    textConfirm: "Confirm",
                    textCancel: "Cancel",
                    cancelTextColor: Colors.black,
                    confirmTextColor: Colors.black,
                    buttonColor: Colors.grey,
                    barrierDismissible: false,
                    radius: 50,
                    onConfirm: () {
                      _clear();
                      Get.to(HomePage());
                    });
              } else {
                _clear();
                Get.to(HomePage());
              }
             return false;
          },
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "img/Logo Light ESI-SBA 175.png",
                    height: 100,
                  ),
                  const Divider(
                    endIndent: 40,
                    indent: 40,
                    color: Colors.deepPurple,
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Change post type :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        isExpanded: true,
                        iconSize: 25,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        value: widget.value,
                        items: items.map(buildMenuItem).toList(),
                        onChanged: (item) => setState(() {
                              widget.value = item!;
                              formKey.currentState?.save();
        
                              if (description != null) {
                                widget.cont = description!;
                              }
                            })),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Change discreption :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: TextEditingController(text: widget.cont),
                  onSaved: (val) {
                    description = val!;
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field cannot be empty!";
                    }
        
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Add discription",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  maxLines: 5,
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: img != null
                    ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            img!,
                            height: 300,
                          ),
                        ),
                      )
                    : widget.img != ""
                        ? Ink.image(
                            image: NetworkImage(widget.img),
                            height: 300,
                          )
                        : Image.asset(
                            "img/logo.png",
                            height: 150,
                          ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: img == null || widget.img != ""
                    ? null
                    : ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Choose diractory",
                              backgroundColor: Colors.white,
                              titleStyle: const TextStyle(color: Colors.black),
                              middleTextStyle:
                                  const TextStyle(color: Colors.white),
                              textCancel: "Cancel",
                              cancelTextColor: Colors.black,
                              buttonColor: Colors.black,
                              barrierDismissible: false,
                              radius: 50,
                              content: Column(children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _uploadImage(false);
                                    formKey.currentState?.save();
        
                                    setState(() {
                                      if (description != null) {
                                        widget.cont = description!;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children:const [
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
                                    _uploadImage(true);
                                    formKey.currentState?.save();
        
                                    setState(() {
                                      if (description != null) {
                                        widget.cont = description!;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children:const [
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
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          child: const Center(
                              child: Text(
                            "Change image",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                        ),
                      ),
              ),
              const SizedBox(
                height: 7,
              ),
              img != null || widget.img != ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 140),
                      child: ElevatedButton(
                        onPressed: () async {
                          _clear();
                          formKey.currentState?.save();
        
                          setState(() {
                            if (description != null) {
                              widget.cont = description!;
                              widget.img = "";
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: const Center(
                              child:  Text(
                            "Remove image",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          )),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: ElevatedButton(
                  onPressed: () async {
                    formKey.currentState?.save();
                    if (formKey.currentState!.validate()) {
                      if (widget.value != null) {
                        Get.defaultDialog(
                            title: "Confirmation",
                            middleText: "Are you sure about the informations ?",
                            backgroundColor: Colors.white,
                            textConfirm: "Confirm",
                            textCancel: "Cancel",
                            cancelTextColor: Colors.black,
                            confirmTextColor: Colors.black,
                            buttonColor: Colors.grey,
                            barrierDismissible: false,
                            radius: 50,
                            onConfirm: () async {
                              Get.back();
                              Get.defaultDialog(
                                confirm: CircularProgressIndicator(),
                                title: "Loading",
                                middleText: "please wait ...",
                                backgroundColor: Colors.white,
                                barrierDismissible: false,
                                radius: 20,
                              );
                              var hasconnection =
                                              await InternetConnectionChecker()
                                                  .hasConnection;
                                          if (hasconnection == true){
                                               await uploadFile();
                              if (img != null) {
                                await FirebaseFirestore.instance
                                    .collection("Posts")
                                    .doc(widget.id)
                                    .update({
                                  "postType": widget.value,
                                  "picture": urlDownload,
                                  "description": description,
                                  "edited": true,
                                });
                              } else {
                                await FirebaseFirestore.instance
                                    .collection("Posts")
                                    .doc(widget.id)
                                    .update({
                                  "postType": widget.value,
                                  "picture": widget.img,
                                  "description": description,
                                  "edited": true,
                                });
                              }
                              Get.back();
                              Get.defaultDialog(
                                  title: "Post",
                                  middleText:
                                      "You have updated your post successfully.\n\n Go to home page?",
                                  backgroundColor: Colors.white,
                                  textConfirm: "Confirm",
                                  textCancel: "Cancel",
                                  cancelTextColor: Colors.black,
                                  confirmTextColor: Colors.black,
                                  buttonColor: Colors.grey,
                                  barrierDismissible: false,
                                  radius: 20,
                                  onConfirm: () {
                                    _clear();
                                    Get.back();
                                    Get.to(HomePage());
                                  });
                                          }else{
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
                           
                              // Get.dialog(
                              //   AlertDialog(
                              //     title: const Text('Post'),
                              //     content: const Text(
                              //         'You have created a post successfully.'),
                              //     actions: [
                              //       TextButton(
                              //         child: const Text("Close"),
                              //         onPressed: () => Get.back(),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            });
                      } else if (widget.value == null) {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please select a post type!.'),
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
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: const Center(
                        child: Text(
                      "Save changes",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 15),
        ),
      );

  Future<CroppedFile?> _cropImage() async {
    if (img != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: originalImg!.path,
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

  Future _uploadImage(bool? isGallery) async {
    final pickedFile = await ImagePicker().pickImage(
        source: isGallery == true ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        originalImg = File(pickedFile.path);
        img = File(pickedFile.path);
      });
    }
  }

  void _clear() {
    setState(() {
      img = null;
      originalImg = null;
      _croppedFile = null;
    });
  }

  Future uploadFile() async {
    if (img == null) {
    } else {
      File file = File(img!.path);
      var refStorage = FirebaseStorage.instance.ref("posts/${img!}.jpg");
      await refStorage.putFile(file);
      var url = await refStorage.getDownloadURL();
      urlDownload = url;
    }
  }
}
