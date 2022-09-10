import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/User/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHeaderDrawer extends StatefulWidget {
  MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {


  @override
  Widget build(BuildContext context) {
    var doc =  FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    return FutureBuilder<QuerySnapshot>(
      future: doc.get(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return   Container(
      color: Colors.deepPurple,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 10),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Image.asset(
                  "img/Logo Light ESI-SBA 175.png",
                  height: 50,
                ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: "${snapshot.data!.docs[0]['picture']}" != "" ? Material(
                  color: Colors.transparent,
                  child: Ink.image(
                    image: NetworkImage(
                        "${snapshot.data!.docs[0]['picture']}"),
                    fit: BoxFit.cover,
                    width: 85,
                    height: 85,
                    child: InkWell(
                      onTap: (){
                        Get.to(ProfilePage());
                      },
                    ),
                  ),
                ): InkWell(
                        onTap: () {
                          Get.to(ProfilePage());
                        },
                        child: Container(
                         
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 10, color: Colors.white),
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
                            size: 65,
                            color: Colors.grey.shade300,
                          ),
                        )),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                "${snapshot.data!.docs[0]['firstname']}" + " " + "${snapshot.data!.docs[0]['lastname']}",
                style: TextStyle(color: Colors.grey[200], fontSize: 15),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "${snapshot.data!.docs[0]['email']}",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              )
            ],
          ),
        ),
      ]),
    );
        }
        return Container(
      color: Colors.deepPurple,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 10),
      child: 
        const Center(child: CircularProgressIndicator(
          color: Colors.black,
        )),
    );  
        
      },
    ); 
  
  }
}
