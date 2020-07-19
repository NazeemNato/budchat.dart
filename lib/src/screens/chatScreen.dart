import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_social/src/models/argMode.dart';
import 'package:flutter/services.dart';
import 'package:my_social/src/widgets/customButton.dart';
import 'package:my_social/src/widgets/message.dart';

class ChatScreen extends StatefulWidget {
  static const String route = '/chat';
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final ChatArg arg = ModalRoute.of(context).settings.arguments;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopChatView(roomId: arg.roomId, userName: arg.userName);
        } else if (constraints.maxWidth > 700 && constraints.maxWidth < 1200) {
          return DesktopChatView(roomId: arg.roomId, userName: arg.userName);
        } else {
          return MobileChatView(roomId: arg.roomId, userName: arg.userName);
        }
      },
    );
  }
}

class DesktopChatView extends StatefulWidget {
  final String roomId, userName;
  DesktopChatView({Key key, @required this.roomId, this.userName})
      : super(key: key);
  @override
  _DesktopChatViewState createState() => _DesktopChatViewState();
}

class _DesktopChatViewState extends State<DesktopChatView> {
  final Firestore _firestore = Firestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> actionCallBack() async {
    if (messageController.text.length > 0) {
      var chat = messageController.text;
      var documentReference = Firestore.instance
          .collection('chat')
          .document(
            widget.roomId,
          )
          .collection(
            widget.roomId,
          )
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(documentReference, {
          'message': chat,
          'user': widget.userName,
          'time': DateTime.now().millisecondsSinceEpoch
        });
      });
      messageController.clear();
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.roomId,
          style: TextStyle(fontSize: 30),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.content_copy,
              color: Colors.white,
            ),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: widget.roomId));
            },
            tooltip: 'Copy room id',
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 150, right: 150),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('chat')
                        .document(widget.roomId)
                        .collection(widget.roomId)
                        .orderBy('time')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                  
                      return Scrollbar(
                        isAlwaysShown: true,
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MessageUi(
                              from: snapshot.data.documents[index]['user'],
                              message: snapshot.data.documents[index]
                                  ['message'],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          keyboardType: TextInputType.multiline,
                          //                maxLines: 5,
                          controller: messageController,
                          onSubmitted: (v) => actionCallBack(),
                          decoration: InputDecoration(
                              hintText: 'Send Message...',
                              border: OutlineInputBorder()),
                        )),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        CustomButton(
                          child: Center(
                              child: Container(
                                  child: Icon(
                            Icons.send,
                            size: 25,
                            color: Colors.white,
                          ))),
                          size: 44,
                          color: Colors.green[500],
                          onPressed: actionCallBack,
                        )
                      ],
                    ))
              ],
            ),
          ),),
    );
  }
}

//m_s[evp_pYpevht
class MobileChatView extends StatefulWidget {
  final String roomId, userName;
  MobileChatView({Key key, @required this.roomId, this.userName})
      : super(key: key);

  @override
  _MobileChatViewState createState() => _MobileChatViewState();
}

class _MobileChatViewState extends State<MobileChatView> {
  final Firestore _firestore = Firestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> actionCallBack() async {
    if (messageController.text.length > 0) {
      var chat = messageController.text;
      var documentReference = Firestore.instance
          .collection('chat')
          .document(
            widget.roomId,
          )
          .collection(
            widget.roomId,
          )
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(documentReference, {
          'message': chat,
          'user': widget.userName,
          'time': DateTime.now().millisecondsSinceEpoch
        });
      });
      print(chat);
      messageController.clear();
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: Duration(milliseconds: 300));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(
          widget.roomId,
          style: TextStyle(fontSize: 30),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.content_copy,
              color: Colors.white,
            ),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: widget.roomId));
            },
            tooltip: 'Copy room id',
          ),
        ],
      ),
      body:SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('chat')
                        .document(widget.roomId)
                        .collection(widget.roomId)
                        .orderBy('time')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                  
                      return Scrollbar(
                        isAlwaysShown: true,
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MessageUi(
                              from: snapshot.data.documents[index]['user'],
                              message: snapshot.data.documents[index]
                                  ['message'],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          keyboardType: TextInputType.multiline,
                                        //  maxLines: 5,
                          controller: messageController,
                          onSubmitted: (v) => actionCallBack(),
                          decoration: InputDecoration(
                              hintText: 'Send Message...',
                              border: OutlineInputBorder()),
                        )),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        CustomButton(
                          child: Center(
                              child: Container(
                                  child: Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.white,
                          ))),
                          size: 35,
                          color: Colors.green[500],
                          onPressed: actionCallBack,
                        )
                      ],
                    ))
              ],
            ),
          )
    );
  }
}
