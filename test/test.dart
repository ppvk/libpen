import 'package:libpen/libpen.dart';
import 'dart:async';
import 'dart:math';
import 'dart:html' as html;

Random r = new Random();
main() {
  Console root = new Console(80, 50);
  html.document.body.append(root.container);
  root.clear();
  new Timer.periodic(new Duration(milliseconds: 1), (_) {
    root.drawText(0, 0, 'Overdraw?');
  });
  
  new Mouse()
  ..onClick.listen((Map data){
    root.setChar(data['cell'].x, data['cell'].y,r.nextInt(200));
    print(data);
    root.flush();
  });
  

  new Timer.periodic(new Duration(seconds:1), (_) => root.flush());
  
}

