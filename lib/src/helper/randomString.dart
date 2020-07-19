import 'dart:math';

String randomString(int count){
  var codeUnits = List.generate(count,(index)=>Random().nextInt(33)+89);
  return new String.fromCharCodes(codeUnits);
}