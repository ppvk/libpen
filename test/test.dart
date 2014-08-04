import 'package:libpen/libpen.dart';
import 'dart:async';
import 'dart:math';
import 'dart:html' as html;

Random r = new Random();
main() {
  Console root = new Console(50, 30);
  html.document.body.append(root.container);
  root.clear();
  root.setCharBackground(5, 5, RED);
  
  new Timer.periodic(new Duration(milliseconds: 1), (_) {
    root.putChar(r.nextInt(50), r.nextInt(30), r.nextInt(256), new Color(r.nextInt(255),r.nextInt(255),r.nextInt(255)),  new Color(r.nextInt(255),r.nextInt(255),r.nextInt(255)));
  });

  new Timer.periodic(new Duration(milliseconds:5), (_) => root.flush());
  
}

