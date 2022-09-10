import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esi_sba_lost_object/Home/HomePage.dart';
import 'package:esi_sba_lost_object/Post/EditPostPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Auth/showLoading.dart';
import '../User/ViewAs.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;

var detroit = tz.getLocation('Africa/Algiers');
var now= tz.TZDateTime.now(detroit);

class Post extends StatefulWidget {
  final bool mine, edited, myPosts;
  final String picture, postType, owner, id, date, description;
  Post(
      {Key? key,
      required this.picture,
      required this.date,
      required this.description,
      required this.mine,
      required this.owner,
      required this.edited,
      required this.postType,
      required this.id,
      required this.myPosts})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}
 
class _PostState extends State<Post> {
  @override
void initState() {
    // TODO: implement initState
    super.initState();
        tz.initializeTimeZones();

  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      now = tz.TZDateTime.now(detroit);
    });
    var selectedItem = '';
    var doc = FirebaseFirestore.instance
        .collection("Users")
        .where("owner", isEqualTo: widget.owner);

    return FutureBuilder<QuerySnapshot>(
      future: doc.get(),
      builder: (context, snapshot) {
        DateTime dt1 = DateTime.parse(widget.date);
       DateTime dt2 = DateTime.parse(DateFormat('yyyy-MM-dd hh:mm:ss').format(now));
      
              


        Duration durdef = dt2.difference(dt1);

        if (snapshot.connectionState == ConnectionState.done) {
          int inMont = 0;
          int inYears = 0;
          if (durdef.inDays > 30) {
            inMont = int.parse(durdef.inDays.toString()) ~/ 30;
          }
          if (inMont > 12) {
            inYears = inMont ~/ 12;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              child: Card(
                color: Colors.grey[300],
                elevation: 0,
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.myPosts == true
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Text(
                                "Post type :  " + widget.postType,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      Row(
                        children: [
                          Padding(
                            padding: widget.myPosts == false
                                ? const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20)
                                : const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                            child: ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: snapshot.data!.docs[0]['picture'] != ""
                                    ? Ink.image(
                                        image: NetworkImage(
                                            snapshot.data!.docs[0]['picture']),
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 70,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(ViewAsPage(
                                                email: snapshot.data!.docs[0]
                                                    ['email'],
                                                phone: snapshot.data!.docs[0]
                                                    ['phone'],
                                                firstname: snapshot
                                                    .data!.docs[0]['firstname'],
                                                lastname: snapshot.data!.docs[0]
                                                    ['lastname'],
                                                picture: snapshot.data!.docs[0]
                                                    ['picture'],
                                                join: snapshot.data!.docs[0]
                                                    ['join'],
                                                about: snapshot.data!.docs[0]
                                                    ['about']));
                                          },
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                               Get.to(ViewAsPage(
                                                email: snapshot.data!.docs[0]
                                                    ['email'],
                                                phone: snapshot.data!.docs[0]
                                                    ['phone'],
                                                firstname: snapshot
                                                    .data!.docs[0]['firstname'],
                                                lastname: snapshot.data!.docs[0]
                                                    ['lastname'],
                                                picture: snapshot.data!.docs[0]
                                                    ['picture'],
                                                join: snapshot.data!.docs[0]
                                                    ['join'],
                                                about: snapshot.data!.docs[0]
                                                    ['about']));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                width: 10, color: Colors.white),
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
                                            size: 55,
                                            color: Colors.grey.shade300,
                                          ),
                                        )),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  snapshot.data!.docs[0]['firstname'] +
                                      " " +
                                      snapshot.data!.docs[0]['lastname'],
                                  style: GoogleFonts.ubuntu(
                                    //  fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    // color: HexColor("#001d4f")
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              widget.edited == false
                                  ? Text(
                                      inYears != 0
                                          ? "$inYears. y ago"
                                          : inMont != 0
                                              ? "$inMont m ago"
                                              : durdef.inDays != 0
                                                  ? "${durdef.inDays} d ago"
                                                  : durdef.inHours > 0.9
                                                      ? "${durdef.inHours} h ago"
                                                      : durdef.inMinutes > 0.9
                                                          ? "${durdef.inMinutes} min ago"
                                                          : "now",
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 12),
                                    )
                                  : Text(
                                      inYears != 0
                                          ? "$inYears. y ago (edited)"
                                          : inMont ~/ 1 != 0
                                              ? "$inMont m ago (edited)"
                                              : durdef.inDays > 0.9
                                                  ? "${durdef.inDays} d ago (edited)"
                                                  : durdef.inHours > 0.9
                                                      ? "${durdef.inHours} h ago (edited)"
                                                      : durdef.inMinutes > 0.9
                                                          ? "${durdef.inMinutes} min ago (edited)"
                                                          : "now (edited)",
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 12),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          widget.description,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      widget.picture != ""
                          ? const Divider(
                              endIndent: 40,
                              indent: 40,
                              color: Colors.black,
                              height: 20,
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          child: widget.picture != ""
                              ?
                              FullScreenWidget(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.network(
                                        widget.picture,
                                    //    height: 170,
                                      )),
                                )
                              : null,
                        ),
                      ),
                      widget.mine != true
                          ? const Divider(
                              endIndent: 40,
                              indent: 40,
                              color: Colors.black,
                              height: 20,
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.mine == false
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 00),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(ViewAsPage(
                                          email: snapshot.data!.docs[0]
                                              ['email'],
                                          phone: snapshot.data!.docs[0]
                                              ['phone'],
                                          firstname: snapshot.data!.docs[0]
                                              ['firstname'],
                                          lastname: snapshot.data!.docs[0]
                                              ['lastname'],
                                          picture: snapshot.data!.docs[0]
                                              ['picture'],
                                          join: snapshot.data!.docs[0]['join'],
                                          about: snapshot.data!.docs[0]
                                              ['about']));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 12),
                                      child: const Center(
                                          child: Text(
                                        "Contact",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          // ElevatedButton.icon(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.comment, size: 18),
                          //   style: ElevatedButton.styleFrom(
                          //       primary: Colors.grey,
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(20))),
                          //   label: Container(
                          //     padding: const EdgeInsets.all(10),
                          //     child: const Center(
                          //         child: Text(
                          //       "comment (4)",
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 16),
                          //     )),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height:  20,
                      )
                    ],
                  ),
                  widget.mine == true
                      ? Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton(
                                onSelected: (value) async {
                                  setState(() {
                                    selectedItem = value.toString();
                                  });
                                  if (selectedItem == "1") {
                                    await Get.defaultDialog(
                                        title: "Confirmation",
                                        middleText:
                                            "Are you sure you want to delete this post ?",
                                        backgroundColor: Colors.white,
                                        textConfirm: "Confirm",
                                        textCancel: "Cancel",
                                        cancelTextColor: Colors.black,
                                        confirmTextColor: Colors.black,
                                        buttonColor: Colors.grey,
                                        barrierDismissible: false,
                                        radius: 50,
                                        onConfirm: () async {
                                          showLoading(context);
                                          await FirebaseFirestore.instance
                                              .collection("Posts")
                                              .doc(widget.id)
                                              .delete();
                                          Navigator.of(context).pop();
                                          await Get.dialog(AlertDialog(
                                            title: const Text('Alert'),
                                            content: const Text(
                                                'You have deleted the post successfully.'),
                                            actions: [
                                              TextButton(
                                                child: const Text("Close"),
                                                onPressed: () =>
                                                    Get.to(HomePage()),
                                              ),
                                            ],
                                          ));
                                          Get.to(HomePage());
                                        });
                                  }
                                  if (selectedItem == "2") {
                                    Get.to(EditPostPage(
                                      cont: widget.description,
                                      value: widget.postType,
                                      img: widget.picture,
                                      id: widget.id,
                                    ));
                                  }
                                },
                                itemBuilder: (BuildContext) {
                                  return [
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("Delete"),
                                        ],
                                      ),
                                      value: '1',
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_calendar_outlined),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("Edit"),
                                        ],
                                      ),
                                      value: '2',
                                    )
                                  ];
                                },
                              )),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                ]),
              ),
            ),
          );
        }
        return const SizedBox(
          height: 0,
        );
      },
    );
  }
}
