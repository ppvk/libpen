library test;
import 'package:libpen/libpen.dart';
import 'dart:async';
import 'dart:math';
import 'dart:html' as html;

part 'test_color.dart';

Random r = new Random();
main() {  
  testColors();
  
  Console console = new Console(10,10);
  html.document.body.append(console.container);
  
  Image i = new Image(10,10);
  for (Char char in i.charData)
    char
      ..glyph = 2
      ..backColor = TRANSPARENT;
  
  console.drawImage(2, 2, i);
  
  console.setChar(5, 5, '5');
  console.flush();
}

