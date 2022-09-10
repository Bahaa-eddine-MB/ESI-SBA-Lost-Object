import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTheAppPage extends StatelessWidget {
  const AboutTheAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: Text('ABOUT THE APPLICATION',
            style: GoogleFonts.ubuntu(fontSize: 17, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Lottie.asset("img/about.json",height: 300),
                  const Text(
                    "This application was developed by an ESI-SBA student for ESI-SBA students in-order to make it easier to find there lost objects and avoid using the professional mail\n \"The application is still in the test mode\"",
                    textAlign: TextAlign.center,style: TextStyle(fontSize: 18 ),
                  ),
            
                     const SizedBox(
              height: 50,
            ),
            Image.asset(
              "img/logo.png",
              height: 150,
            ),
           
               const   SizedBox(
                    height: 25,
                  ),
                const  Text("Developed by : ",style: TextStyle(fontWeight:FontWeight.bold),textAlign: TextAlign.left,),
                const   SizedBox(
                    height: 5,
                  ),
               const   Text("Bouzeboudja Bahaa Eddine",style: TextStyle(fontWeight:FontWeight.bold),textAlign: TextAlign.left,),
                 const   SizedBox(
                    height: 5,
                  ),
                  TextButton(onPressed: (){
                     final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: "be.bahaaeddine@gmail.com",
                       
                          );

                          launchUrl(emailLaunchUri);
                  }, child:  const   Text("Contact me : be.bahaaeddine@gmail.com"))
              
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
