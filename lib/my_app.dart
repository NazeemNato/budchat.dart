import 'package:flutter/material.dart';
import 'package:my_social/src/screens/chatScreen.dart';
import 'package:my_social/src/screens/homeScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Budchat',
      initialRoute: HomeScreen.route,
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.route:(context)=>HomeScreen(),
        ChatScreen.route:(context)=>ChatScreen()
      },
    );
  }
}