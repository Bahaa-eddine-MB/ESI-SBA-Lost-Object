import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'Post.dart';



class FoundObjectPage extends StatefulWidget {
  FoundObjectPage({Key? key}) : super(key: key);

  @override
  State<FoundObjectPage> createState() => _FoundObjectPageState();
}

class _FoundObjectPageState extends State<FoundObjectPage> {
  @override
  Widget build(BuildContext context) {
    var doc =  FirebaseFirestore.instance
        .collection("Posts")
        .where("postType", isEqualTo: "Found Object");
    return SafeArea(
        child: SingleChildScrollView(
      child: 
      Column(
        children: [
           Lottie.asset("img/done.json",height: 200),
            const Divider(
               endIndent: 40,
              indent: 40,
              color: Colors.deepPurple,
              height: 20,
            ),         
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
                  return snapshot.data!.docs[index]['owner'] == FirebaseAuth.instance.currentUser!.uid ?
                   Post(myPosts: false,id: snapshot.data!.docs[index]['id'],picture: snapshot.data!.docs[index]['picture'], date: snapshot.data!.docs[index]['date'], description: snapshot.data!.docs[index]['description'], mine: true, owner: snapshot.data!.docs[index]['owner'],edited: snapshot.data!.docs[index]['edited'],postType: snapshot.data!.docs[index]['postType'],) :  Post(myPosts: false,picture: snapshot.data!.docs[index]['picture'], date: snapshot.data!.docs[index]['date'], description: snapshot.data!.docs[index]['description'], mine: false, owner: snapshot.data!.docs[index]['owner'],edited: snapshot.data!.docs[index]['edited'],postType: snapshot.data!.docs[index]['postType'],id: snapshot.data!.docs[index]['id']) ;
                },
              );
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.data!.docs.isEmpty){
          return Column(
            children: const [
              SizedBox(height: 150,),
              Center(
                child: Text("No posts availble"),
              ),
            ],
          );
        }
        return   Column(
            children: const [
                            SizedBox(height: 150,),
               Center(child: CircularProgressIndicator(
                color: Colors.black,
              )),
            ],
          );
      },
    )
        ],
      ),
    ));
  }
}
