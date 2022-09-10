import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/Auth/ConfirmEmailPage.dart';
import 'package:esi_sba_lost_object/Home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'logingScreen.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
  
class _SplashScreenState extends State<SplashScreen> {
  
  @override
  Widget build(BuildContext context) {
    
    return AnimatedSplashScreen(
      splash: 
      Column(children: [
        const SizedBox(
          height: 20,
        ),
        Lottie.asset("img/28344-page-not-found-animation.json",height: 250),
         const SizedBox(
          height: 20,
        ),
        const Text(
          "ESI-SBA lost object",
          style: TextStyle(
              fontSize: 20,  color: Colors.white),
        )
      ]),
      backgroundColor: Colors.deepPurple,
      splashIconSize: 400,
      splashTransition: SplashTransition.fadeTransition,
      nextScreen: whereGoing(),
      animationDuration: const Duration(milliseconds: 1500),
      pageTransitionType: PageTransitionType.fade
    );
  }

 Widget whereGoing(){
    if(FirebaseAuth.instance.currentUser == null) {
      return loginScreen();
    } else if( FirebaseAuth.instance.currentUser !=null && FirebaseAuth.instance.currentUser!.emailVerified == false){
      return ConfirmEmailPage();
    }else{
      return HomePage();
    }
  }
}
