import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageUi extends StatelessWidget {
  final String from;
  final String message;
  const MessageUi({Key key, this.from, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height:5),
         Text(from,style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height:5),
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 6,
            child: Container(
              padding:EdgeInsets.symmetric(vertical:10,horizontal:15),
              child:Text(message,
              style:GoogleFonts.quicksand()
              ),
            ),
          )
        ],
      ),
    );
  }
}