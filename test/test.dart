library test;
import 'package:libpen/libpen.dart';
import 'dart:math';
import 'dart:html' as html;

part 'test_color.dart';
part 'test_draw.dart';

Random r = new Random();
main() {  
  testColors();
  testDraw();

  Mouse.sharedInstance().onClick.listen(print);
}

frame(Console console) {
  html.window.requestAnimationFrame((_) {
    console.flush();
    frame(console);
  });
}