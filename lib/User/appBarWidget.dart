import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar buildAppBar(BuildContext context){
  final my_icon = CupertinoIcons.moon_stars;
  return AppBar(
    leading: BackButton(
      onPressed: (){
        Get.back();
      },
      color: Colors.black,
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    // actions: [
    //   IconButton(
    //   onPressed: (){}, 
    //   icon:Icon(my_icon,color: Colors.black,) ),
       
    // ],
  );
}