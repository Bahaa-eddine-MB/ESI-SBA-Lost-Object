import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/Post/Post.dart';
import 'package:esi_sba_lost_object/User/appBarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Home/HomePage.dart';

class MyPosts extends StatefulWidget {
  MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
   Widget build(BuildContext context) {
    var doc =  FirebaseFirestore.instance
        .collection("Posts")
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: 
        Column(
          children: [
                  
            FutureBuilder<QuerySnapshot>(
        future: doc.get(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData  && snapshot.data!.docs.isNotEmpty && doc.get()!=null){
            return  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount:
                      snapshot.data!.docs.length, //how many doctors in the list
                  itemBuilder: (context, index) {
                    //the input list of doctors
                    return 
                     Post(myPosts: true,id: snapshot.data!.docs[index]['id'],picture: snapshot.data!.docs[index]['picture'], date: snapshot.data!.docs[index]['date'], description: snapshot.data!.docs[index]['description'], mine: true, owner: snapshot.data!.docs[index]['owner'],edited:snapshot.data!.docs[index]['edited'] ,postType: snapshot.data!.docs[index]['postType'],)
                     ;
                  },
                );
          }   if(snapshot.connectionState == ConnectionState.done && snapshot.data!.docs.isEmpty){
          return Column(
            children: const [
              SizedBox(height: 250,),
              Center(
                child: Text("No posts availble"),
              ),
            ],
          );
        }
          return Column(
            children:const [
               SizedBox(height: 250,),
               Center(child: CircularProgressIndicator(
                color: Colors.black,
              )),
            ],
          );
        },
      )
          ],
        ),
      )),
    );
  }
}
