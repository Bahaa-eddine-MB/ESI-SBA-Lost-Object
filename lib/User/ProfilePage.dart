import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/User/ViewAs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Home/HomePage.dart';
import 'EditProfilePage.dart';
import 'appBarWidget.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late File img;
 // String? firstname, lastname, about, email, phone, picture, join;
 // var doc;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   //getData();
  //   getDoc();
  // }
  // getDoc()async{
  //  doc = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
        
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
  //         join = element.data()["join"];
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
  //   await FirebaseFirestore.instance
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
    var doc = FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
        appBar: AppBar(
    leading: BackButton(
      onPressed: (){
        Get.to(HomePage());
      },
      color: Colors.black,
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
   
  ),
        body: FutureBuilder<QuerySnapshot>(
      future: doc.get(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          print(snapshot.data!.docs[0]['picture']);
          return
              ListView(
               
              physics: const BouncingScrollPhysics(),
              children: [
                Center(
                  child: Stack(children: [
                    ClipOval(
                      child: snapshot.data!.docs[0]['picture'] != ""
                          ? Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                image: NetworkImage(snapshot.data!.docs[0]['picture']),
                                fit: BoxFit.cover,
                                width: 128,
                                height: 128,
                                child: InkWell(onTap: () {
                                  Get.to(const EditProfilePage());
                                }),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Get.to(const EditProfilePage());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 25, color: Colors.white),
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
                    ),
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
                  children: [
                    Text(
                      
                      "${snapshot.data!.docs[0]['firstname']}" + " " + "${snapshot.data!.docs[0]['lastname']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${snapshot.data!.docs[0]['email']}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${snapshot.data!.docs[0]['phone']}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(HomePage());
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                            //      fixedSize: const Size(300, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: const Center(
                              child: Text(
                            "Check posts",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(ViewAsPage(about: snapshot.data!.docs[0]['about'],
                            email: snapshot.data!.docs[0]['email'],
                            firstname: snapshot.data!.docs[0]['firstname'],
                            lastname: snapshot.data!.docs[0]['lastname'],
                            phone: snapshot.data!.docs[0]['phone'],
                            picture: snapshot.data!.docs[0]['picture'],
                            join:  snapshot.data!.docs[0]['join'],
                          ));
                        },
                        child: Container(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                "  View As",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    "About :",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    snapshot.data!.docs[0]['about'] == "" ? "Empty" : "${snapshot.data!.docs[0]['about']}",
                    style: const TextStyle(fontSize: 15),
                  ),
                )
              ],
            );
        }
        return  const Center(child: CircularProgressIndicator(
          color: Colors.black,
        ));
      },
    ) 
    
    );
       
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
            color: color,
            all: 8,
            child: const Icon(
              Icons.edit,
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
}
