library test;
import 'package:libpen/libpen.dart';
import 'package:libpen/gui.dart';
import 'dart:math';
import 'dart:html' as html;

part 'test_color.dart';
part 'test_draw.dart';

Random r = new Random();
Renderer renderer;

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