import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/User/ViewAs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
        
          height: 52,
            child: Card(   
                child: TextFormField(
                  decoration:
                  const InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search...') ,
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
          ),
       
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, snapshots) {
            if (name.isEmpty) {
              return Center(
                child: Container(
                  child: const Text("Search for someone"),
                ),
              );
            }
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      String fullname =
                          data["firstname"] + " " + data["lastname"];

                      if (fullname
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          onTap: () {
                            Get.to(ViewAsPage(
                                email: data["email"],
                                phone: data['phone'],
                                firstname: data["firstname"],
                                lastname: data["lastname"],
                                picture: data["picture"],
                                join: data["join"],
                                about: data["about"]));
                          },
                          title: Text(
                            data['firstname'] + " " + data["lastname"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold), 
                          ),
                          leading: data['picture'] != "" ? CircleAvatar(
                            
                            backgroundImage:  NetworkImage(data['picture']),
                          ):const  CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person,color: Colors.white,)),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
