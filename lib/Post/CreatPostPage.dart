import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/Home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../main.dart';
import 'package:http/http.dart' as http;

class CreatPostPage extends StatefulWidget {
  CreatPostPage({Key? key}) : super(key: key);

  @override
  State<CreatPostPage> createState() => _CreatPostPageState();
}

File? img, originalImg;
bool image = false;
CroppedFile? _croppedFile;
String urlDownload = "";
String cont = "";
var doc = FirebaseFirestore.instance
    .collection("Users")
    .where("owner", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid);

class _CreatPostPageState extends State<CreatPostPage> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    requestPermission();

    loadFCM();

    listenFCM();
  }

  String? value;
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
                          cont = description!;
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
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                  child: FloatingActionButton(
                    onPressed: () {
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
                                _uploadImage(false);
                                formKey.currentState?.save();
                                setState(() {
                                  if (description != null) {
                                    cont = description!;
                                  }
                                });
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
                                _uploadImage(true);
                                formKey.currentState?.save();
                                setState(() {
                                  if (description != null) {
                                    cont = description!;
                                  }
                                });
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
                      // _uploadImage();
                    },
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                        cont = "";
                        _clear();
                        Get.to(HomePage());
                      });
                } else {
                  Get.to(HomePage());
                }
              },
              color: Colors.black,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: WillPopScope(
            onWillPop: () async {
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
                    "Post type :",
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
                          value: value,
                          items: items.map(buildMenuItem).toList(),
                          onChanged: (item) => setState(() {
                                value = item;
                                formKey.currentState?.save();

                                if (description != null) {
                                  cont = description!;
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
                    "Discreption :",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: TextEditingController(text: cont),
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
                  child: img == null
                      ? null
                      : ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                                title: "Choose diractory",
                                backgroundColor: Colors.white,
                                titleStyle:
                                    const TextStyle(color: Colors.black),
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
                                          cont = description!;
                                        }
                                      });
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
                                      _uploadImage(true);
                                      formKey.currentState?.save();

                                      setState(() {
                                        if (description != null) {
                                          cont = description!;
                                        }
                                      });
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
                img != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 140),
                        child: ElevatedButton(
                          onPressed: () {
                            _clear();
                            formKey.currentState?.save();

                            setState(() {
                              if (description != null) {
                                cont = description!;
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
                                child: Text(
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
                FutureBuilder<QuerySnapshot>(
                    future: doc.get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                            onPressed: () async {
                              formKey.currentState?.save();
                              if (formKey.currentState!.validate()) {
                                var detroit = tz.getLocation('Africa/Algiers');
                                var now = tz.TZDateTime.now(detroit);
                                if (value != null) {
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
                                        Get.back();
                                        Get.defaultDialog(
                                          confirm:
                                              const CircularProgressIndicator(),
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
                                          var ref = await FirebaseFirestore
                                              .instance
                                              .collection("Posts")
                                              .doc();

                                          if (img != null) {
                                            await uploadFile();
                                            await ref.set({
                                              "id": ref.id,
                                              "edited": false,
                                              "owner": FirebaseAuth
                                                  .instance.currentUser?.uid,
                                              "postType": value,
                                              "picture": urlDownload,
                                              "description": description,
                                              "date": DateFormat(
                                                      'yyyy-MM-dd hh:mm:ss')
                                                  .format(now)
                                            });
                                            Get.back();

                                            await Get.dialog(
                                              AlertDialog(
                                                title: const Text('Post'),
                                                content: const Text(
                                                    'You have created a post successfully.'),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("Okay"),
                                                    onPressed: () {
                                                      _clear();
                                                      cont = "";
                                                      Get.to(HomePage());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                            _clear();
                                            Get.to(HomePage());
                                          }
                                          if (img == null) {
                                            await ref.set({
                                              "id": ref.id,
                                              "edited": false,
                                              "owner": FirebaseAuth
                                                  .instance.currentUser?.uid,
                                              "postType": value,
                                              "picture": "",
                                              "description": description,
                                              "date": DateFormat(
                                                      'yyyy-MM-dd hh:mm:ss')
                                                  .format(now),
                                            });
                                            snapshot.data!.docs
                                                .forEach((element) {
                                              if (element["notification"] ==
                                                  true) {
                                                sendPushMessage(
                                                    element['token'],
                                                    "$value : $description",
                                                    "$firstname $lastname has created a post");
                                              }
                                            });

                                            Get.back();

                                            await Get.dialog(
                                              AlertDialog(
                                                title: const Text('Post'),
                                                content: const Text(
                                                    'You have created a post successfully.'),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("Okay"),
                                                    onPressed: () {
                                                      _clear();
                                                      cont = "";
                                                      Get.to(HomePage());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                            _clear();
                                            Get.to(HomePage());
                                          }
                                        } else {
                                          Get.back();
                                          Get.snackbar(
                                            "Error",
                                            "No internet connection.",
                                            icon: const Icon(
                                                Icons.portable_wifi_off,
                                                color: Colors.white),
                                            snackPosition: SnackPosition.BOTTOM,
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
                                } else if (value == null) {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Please select a post type!.'),
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
                                "Post",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )),
                            ),
                          ),
                        );
                      }
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      ));
                    }),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
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

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'channelId',
                'channelName',
                channelDescription: 'description',
                importance: Importance.max,
                priority: Priority.max,
                playSound: true,
                icon: '@drawable/ic_stat_logo',
              ),
            ));
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void sendPushMessage(String? token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA7pMhuEw:APA91bFENE_VgBbt-lVHE0JlKD9tgfaSQK_QTH6V4wgX5FPUkN9GFCyrGDJNBKBXW2jAkIYW-demCtCc4ARLd6qLAvkFRf9Kg4dmxbq2PwnC1nKBo64YYwSgK6DIedeBTPIIofFJ3Ua4',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
}
