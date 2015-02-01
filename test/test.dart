library test;
import 'package:libpen/libpen.dart';
import 'dart:async';
import 'dart:math';
import 'dart:html' as html;

part 'test_color.dart';
part 'test_draw.dart';

Random r = new Random();
main() {  
  testColors();
  testDraw();
}

frame(Console console) {
  html.window.requestAnimationFrame((_) {
    console.flush();
    frame(console);
  });
}