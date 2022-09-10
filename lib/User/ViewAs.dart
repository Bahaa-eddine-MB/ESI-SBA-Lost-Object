import 'package:esi_sba_lost_object/User/userPrefrences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAsPage extends StatefulWidget {
  ViewAsPage(
      {Key? key,
      required this.email,
      required this.phone,
      required this.firstname,
      required this.lastname,
      required this.picture,
      required this.join,
      required this.about})
      : super(key: key);
  final String email;
  final String phone;
  final String about;
  final String firstname, lastname, picture, join;
  @override
  State<ViewAsPage> createState() => _ViewAsPageState();
}

class _ViewAsPageState extends State<ViewAsPage> {
  final user = UserPrefrences.myUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "img/Logo Light ESI-SBA 175.png",
              height: 150,
            ),
            const Divider(
              endIndent: 40,
              indent: 40,
              color: Colors.deepPurple,
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: widget.picture != ""
                      ? Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            image: NetworkImage(widget.picture),
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        )
                      : InkWell(
                          child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 25, color: Colors.white),
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
                            size: 75,
                            color: Colors.grey.shade300,
                          ),
                        )),
                ),
                const SizedBox(
                  width: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(widget.firstname,
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Text(widget.lastname,
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: HexColor("#001d4f")
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Joined in:" + " ${widget.join}",
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  ...ListTile.divideTiles(
                    color: Colors.deepPurple,
                    tiles: [
                      ListTile(
                        onTap: () {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: widget.email,
                       
                          );

                          launchUrl(emailLaunchUri);
                        },
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        leading: const Icon(
                          Icons.email_outlined,
                          color: Colors.deepPurple,
                        ),
                        title: const Text("Email :"),
                        subtitle: Text(widget.email),
                      ),
                      ListTile(
                        onTap: () async {
                          if (widget.phone != "") {
                         
                                final Uri emailLaunchUri = Uri(
                            scheme: 'tel',
                            path: widget.phone,
                       
                          );

                          launchUrl(emailLaunchUri);
                          }
                        },
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        leading: const Icon(
                          Icons.phone_outlined,
                          color: Colors.deepPurple,
                        ),
                        title: const Text("Phone :"),
                        subtitle:
                            Text(widget.phone == "" ? "Empty" : widget.phone),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 10, 10),
                        leading: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.deepPurple,
                        ),
                        title: const Text("About Me :"),
                        subtitle:
                            Text(widget.about == "" ? "Empty" : widget.about),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
