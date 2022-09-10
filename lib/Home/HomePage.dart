import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/Home/SearchPage.dart';
import 'package:esi_sba_lost_object/Post/CreatPostPage.dart';
import 'package:esi_sba_lost_object/Post/FoundObject.dart';
import 'package:esi_sba_lost_object/Post/LostObject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'MyDrawerList.dart';
import 'MyHeaderDrawer.dart';

String? firstname,lastname;
bool? notification;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
     FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
          firstname = element.data()["firstname"];
        });
      });
    });
        FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
         lastname= element.data()["lastname"];
        });
      });
    });
     FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
         notification= element.data()["notification"];
        });
      });
    });
    super.initState();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //       const   NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             'channelId',
    //             'channelName',
    //             channelDescription: 'description',
    //             importance: Importance.max,
    //             priority: Priority.max,
    //             playSound: true,
    //             icon: '@drawable/ic_stat_logo',
    //           ),
    //         ));
    //   }
    // });
  }

  // late final LocalNotificationService service;
  // Timer? timer;
  // bool show = false;
  // @override
  // void initState() {
  //   service = LocalNotificationService();
  //   service.initialize();
  //   super.initState();
  //   timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
  //     checkForNewPosts();
  //   });
  // }

  // Future checkForNewPosts() async {
  //   await FirebaseFirestore.instance
  //       .collection("notification")
  //       .get()
  //       .then((value) {
  //     print(value.docs.length);
  //     if (value.docs.length != 0) {
  //       print("yes");
  //       showTheNotification();
  //       FirebaseFirestore.instance.collection("notification").doc("1").delete();
  //     }
  //   });
  // }

  // showTheNotification() async {
  //   await service.showScheduledNotification(
  //       id: 0, title: "titaaale", body: "body",seconds: 1);
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          reflesh();
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              drawer: Drawer(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        MyHeaderDrawer(),
                        MyDrawerList(),
                      ],
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {
                      
                         Get.to(SearchPage());
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                ],
                backgroundColor: Colors.deepPurple,
                title: Text('ESI SBA LOST OBJECT',
                    style: GoogleFonts.ubuntu(fontSize: 17, color: Colors.white)),
                bottom: TabBar(
                  // indicator: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(50), // Creates border
                  //     color: HexColor("#aa81ed")),
                  indicatorWeight: 8,
                  indicatorColor: HexColor("#aa81ed"),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.find_in_page_outlined),
                      text: "Lost Objects",
                    ),
                    Tab(
                      icon: Icon(Icons.file_download_done_outlined),
                      text: "Found Objects",
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [LostObjectPage(), FoundObjectPage()],
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.to(CreatPostPage());
                },
                child: const Icon(
                  Icons.edit,
                  size: 30,
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }

  // void ListenToNotification()=> service.onNotificationClick.stream.listen(onNotification);

  // void onNotification(String? payload) {
  //   if(payload !=null && payload.isNotEmpty){
  //     Get.to(ProfilePage());
  //   }
  // }
  
   void reflesh() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

}
