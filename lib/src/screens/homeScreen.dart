import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_social/src/helper/randomString.dart';
import 'package:my_social/src/models/argMode.dart';
import 'package:my_social/src/screens/chatScreen.dart';
import 'package:my_social/src/widgets/customButton.dart';
import 'package:my_social/src/widgets/showLoading.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopView();
        } else if (constraints.maxWidth > 700 && constraints.maxWidth < 1200) {
          return DesktopView();
        } else {
          return MobileView();
        }
      },
    );
  }
}

class DesktopView extends StatefulWidget {
  DesktopView({Key key}) : super(key: key);

  @override
  _DesktopViewState createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _roomIdController = TextEditingController();
  final Firestore _firestore = Firestore.instance;
  @override
  void dispose() {
    _userNameController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  _alert(context, {String title, String body}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
            style:GoogleFonts.anton(
              color: Colors.red
            )
            ),
            content: Container(
              child: Text(
                body,
                style: GoogleFonts.bebasNeue(
                  fontSize: 25,
                ),//^vexbercoqsdeZi
              ),
            ),
            actions: <Widget>[
              new CustomButton(
                  size: 25,
                  color: Colors.red,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Join',
                style: GoogleFonts.staatliches(fontSize: 50, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 150, right: 150),
              child: Container(
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: GoogleFonts.bebasNeue(),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 150, right: 150),
              child: Container(
                child: TextField(
                  controller: _roomIdController,
                  decoration: InputDecoration(
                    hintStyle: GoogleFonts.bebasNeue(),
                    hintText: 'Room id',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              child: Center(
                child: Container(
                  child: Text(
                    'Enter',
                    style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              size: 50,
              color: Colors.amber,
              onPressed: () {
                showLoading(context);
                try {
                  if (_userNameController.text.isNotEmpty &&
                      _roomIdController.text.isNotEmpty) {
                    _firestore
                        .collection('home')
                        .where('roomId', isEqualTo: _roomIdController.text)
                        .getDocuments()
                        .then((value) async {
                      if (value.documents.isNotEmpty) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(ChatScreen.route,
                            arguments: ChatArg(_userNameController.text,
                                _roomIdController.text));
                      } else {
                        Navigator.of(context).pop();
                        _alert(context,
                            title: 'Invalid', body: 'invalid room id !!');
                      }
                    });
                  } else if (_userNameController.text.isEmpty &&
                      _roomIdController.text.isEmpty) {
                    Navigator.of(context).pop();

                    _alert(context,
                        title: '??', body: 'No username and room id !!');
                  } else if (_userNameController.text.isEmpty &&
                      _roomIdController.text.isNotEmpty) {
                    Navigator.of(context).pop();

                    _alert(context,
                        title: 'Empty', body: 'Please enter username');
                  } else {
                    Navigator.of(context).pop();

                    _alert(context,
                        title: 'Empty', body: 'Please enter room id');
                  }
                } catch (e) {
                  Navigator.of(context).pop();

                    _alert(context,
                        title: 'Error', body: 'Somthing went wrong');
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Create room!'),
                          content: Container(
                              child: TextField(
                            controller: _userNameController,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.bebasNeue(),
                              hintText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          )),
                          actions: <Widget>[
                            new CustomButton(
                              size: 25,
                              color: Colors.red,
                              onPressed: () => Navigator.of(context).pop(),
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                            new CustomButton(
                                size: 25,
                                color: Colors.green,
                                onPressed: () => createRoom(context),
                                child: Icon(Icons.add, color: Colors.white)),
                          ],
                        );
                      });
                },
                child: Text(
                  'create room',
                  style: GoogleFonts.saira(fontSize: 25, color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }

  void createRoom(context) {
    String roomId = randomString(15);
    // Navigator.of(context).pop();
    // showLoading(context);
    try {
      if (_userNameController.text.isNotEmpty) {
        _firestore
            .collection('home')
            .where('roomId', isEqualTo: _roomIdController.text)
            .getDocuments()
            .then((value) async {
          if (value.documents.isEmpty) {
            await _firestore.collection('home').add({
              'roomId': roomId,
              'createdBy': _userNameController.text,
              'time': DateTime.now()
            });
            // Navigator.of(context).pop();
            Navigator.of(context).pushNamed(ChatScreen.route,
                arguments: ChatArg(_userNameController.text, roomId));
          } else {
            await _firestore.collection('home').add({
              'roomId': 'new$roomId',
              'createdBy': _userNameController.text,
              'time': DateTime.now()
            });
            // Navigator.of(context).pop();
            Navigator.of(context).pushNamed(ChatScreen.route,
                arguments: ChatArg(_userNameController.text, 'new$roomId'));
          }
        });
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      Navigator.of(context).pop();
    }
  }
}

class MobileView extends StatefulWidget {
  MobileView({Key key}) : super(key: key);

  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _roomIdController = TextEditingController();
  ScrollController controller = ScrollController();
  final Firestore _firestore = Firestore.instance;
  @override
  void dispose() {
    _userNameController.dispose();
    _roomIdController.dispose();
    controller.dispose();
    super.dispose();
  }

  _alert(context, {String title, String body}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
            style:GoogleFonts.anton(
              color: Colors.red
            )
            ),
            content: Container(
              child: Text(
                body,
                style: GoogleFonts.bebasNeue(
                  fontSize: 25,
                ),
              ),
            ),
            actions: <Widget>[
              new CustomButton(
                  size: 25,
                  color: Colors.red,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
            ),
            Container(
              child: Text(
                'Join',
                style: GoogleFonts.staatliches(fontSize: 40, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
          hintStyle: GoogleFonts.bebasNeue(),
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                child: TextField(
                  controller: _roomIdController,
                  decoration: InputDecoration(
               hintStyle: GoogleFonts.bebasNeue(),
                    hintText: 'Room id',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              child: Center(
                child: Container(
                  child: Text(
                    'Enter',
                    
                    style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              size: 50,
              color: Colors.amber,
              onPressed: (){
                showLoading(context);
                try {
                  if (_userNameController.text.isNotEmpty &&
                      _roomIdController.text.isNotEmpty) {
                    _firestore
                        .collection('home')
                        .where('roomId', isEqualTo: _roomIdController.text)
                        .getDocuments()
                        .then((value) async {
                      if (value.documents.isNotEmpty) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(ChatScreen.route,
                            arguments: ChatArg(_userNameController.text,
                                _roomIdController.text));
                      } else {
                        Navigator.of(context).pop();
                        _alert(context,
                            title: 'Invalid', body: 'invalid room id !!');
                      }
                    });
                  } else if (_userNameController.text.isEmpty &&
                      _roomIdController.text.isEmpty) {
                    Navigator.of(context).pop();

                    _alert(context,
                        title: '??', body: 'No username and room id !!');
                  } else if (_userNameController.text.isEmpty &&
                      _roomIdController.text.isNotEmpty) {
                    Navigator.of(context).pop();

                    _alert(context,
                        title: 'Empty', body: 'Please enter username');
                  } else {
                    Navigator.of(context).pop();

                    _alert(context,
                        title: 'Empty', body: 'Please enter room id');
                  }
                } catch (e) {
                  Navigator.of(context).pop();

                    _alert(context,
                        title: 'Error', body: 'Somthing went wrong');
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Create room!'),
                          content: Container(
                              child: TextField(
                            controller: _userNameController,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.bebasNeue(),
                              hintText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          )),
                          actions: <Widget>[
                            new CustomButton(
                              size: 25,
                              color: Colors.red,
                              onPressed: () => Navigator.of(context).pop(),
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                            new CustomButton(
                                size: 25,
                                color: Colors.green,
                                onPressed: () {
                                  String roomId = randomString(15);
                                  if (_userNameController.text.isNotEmpty) {
                                    _firestore
                                        .collection('home')
                                        .where('roomId',
                                            isEqualTo: _roomIdController
                                                .text.isNotEmpty)
                                        .getDocuments()
                                        .then((value) async {
                                      if (value.documents.isEmpty) {
                                        await _firestore
                                            .collection('home')
                                            .add({
                                          'roomId': roomId,
                                          'createdBy': _userNameController.text,
                                          'time': DateTime.now()
                                        });
                                        Navigator.of(context).pushNamed(
                                            ChatScreen.route,
                                            arguments: ChatArg(
                                                _userNameController.text,
                                                roomId));
                                      } else {
                                        await _firestore
                                            .collection('home')
                                            .add({
                                          'roomId': 'new$roomId',
                                          'createdBy': _userNameController.text,
                                          'time': DateTime.now()
                                        });
                                        Navigator.of(context).pushNamed(
                                            ChatScreen.route,
                                            arguments: ChatArg(
                                                _userNameController.text,
                                                'new$roomId'));
                                      }
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Icon(Icons.add, color: Colors.white)),
                          ],
                        );
                      });
                },
                child: Text(
                  'create room',
                  style: GoogleFonts.saira(fontSize: 25, color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }
}
