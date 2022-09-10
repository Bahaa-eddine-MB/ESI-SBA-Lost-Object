import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Pro extends StatelessWidget {
  const Pro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      var doc =  FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    return FutureBuilder<QuerySnapshot>(
      future: doc.get(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Container(
            
           child:Text ("yes"));
        }
        return Container(
            
           child:Text ("no"));
      },
    );
  }
}