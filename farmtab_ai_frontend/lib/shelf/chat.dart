import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:farmtab_ai_frontend/theme/color_extension.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  List<Map<String, String>> messages = [];
  final TextEditingController controller = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Chat'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.78,
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView(
                    reverse: true,
                    shrinkWrap: true,
                    controller: _scrollController,
                    children: [
                      Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 35,
                                width: 35,
                                child: CircleAvatar(
                                  backgroundImage:
                                  AssetImage("assets/images/shelfA.jpg"),
                                  radius: 65.0,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 15.0),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Text(
                                      'The pH  is lower than optimal for \n'
                                          'spinach. A mild lime treatment could raise\n'
                                          ' the pH to a healthier level. Would you like\n'
                                          ' more details?',
                                      style:
                                      TextStyle(color: Colors.black),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text('10:31 PM',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11.0)),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 15.0),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: TColor.primaryColor1,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Text(
                                      'Sure, please let me know the more \ndetails.',
                                      style:
                                      TextStyle(color: Colors.white),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text('10:34 PM',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11.0)),
                                )
                              ],
                            ),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: 35,
                                width: 35,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/profile_photo.jpg"),
                                  radius: 65.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: 35,
                                width: 35,
                                child: CircleAvatar(
                                  backgroundImage:
                                  AssetImage("assets/images/shelfA.jpg"),
                                  radius: 65.0,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 15.0),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Text(
                                      'Agricultural lime or dolomitic lime works \n'
                                          'well. Dolomitic lime also adds \n'
                                          'magnesium, which may benefit spinach \n'
                                          'if your soil is magnesium-deficient.',
                                      style:
                                      TextStyle(color: Colors.black),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text('10:35 PM',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11.0)),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 15.0),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: TColor.primaryColor1,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Text(
                                      'That would be helpful!',
                                      style:
                                      TextStyle(color: Colors.white),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text('10:36 PM',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11.0)),
                                )
                              ],
                            ),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: 35,
                                width: 35,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/profile_photo.jpg"),
                                  radius: 65.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var i = 0; i < messages.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 15.0),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            color: TColor.primaryColor1,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Text(
                                          messages[i]['body']!,
                                          style: TextStyle(
                                              color: Colors.white),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(messages[i]['time']!,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11.0)),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          messages[i]['author_image']!),
                                      radius: 65.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 3,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      setState(() {
                        messages.add({
                          "body": value,
                          "time": "10:40 PM",
                          "author_image": "assets/img/profile-screen-avatar.jpg"
                        });
                      });
                      _scrollController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                      controller.text = "";
                    },
                    controller: controller,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 15.0),
                      prefixIcon: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 22.0,
                      ),
                      suffixIcon: Icon(
                        Icons.subdirectory_arrow_right,
                        color: Colors.black,
                        size: 22.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
