import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/Auth/logingScreen.dart';
import 'package:esi_sba_lost_object/Home/AboutTheAppPage.dart';
import 'package:esi_sba_lost_object/Home/FeedBackPage.dart';
import 'package:esi_sba_lost_object/User/MyPosts.dart';
import 'package:esi_sba_lost_object/User/ProfilePage.dart';
import 'package:esi_sba_lost_object/User/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawerList extends StatefulWidget {
  MyDrawerList({Key? key}) : super(key: key);

  @override
  State<MyDrawerList> createState() => _MyDrawerListState();
}

class _MyDrawerListState extends State<MyDrawerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          menuItems(ProfilePage(), "My Profile", Icons.person),
          menuItems(MyPosts(), "My Posts", Icons.library_books),
          menuItems(FeedBackPage(), "Feed Back", Icons.feedback),
          menuItems(SettingsPage(), "Settings", Icons.settings),
          menuItems(const AboutTheAppPage(), "About the application",
              Icons.phone_android),
        ],
      ),
    );
  }

  Widget menuItems(Widget page, String title, IconData icon) {
    return Material(
      //   color: selected? Colors.grey[300]:Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(page);
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
