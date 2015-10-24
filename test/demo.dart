import 'dart:html' as html;
import 'dart:math';

import 'package:libpen/console.dart';
import 'package:libpen/gui.dart';

Console console;

Random R = new Random();

main() {
  console = new Console(50,50);
  html.document.body.append(console.container);
  loop();
  Mouse.onClick.listen((e) => print(e));
}

loop() async {
  await html.window.animationFrame;

  console.fill(glyph: 2,
    foreColor:new Color.interpolate(new Color(R.nextInt(255),R.nextInt(255),R.nextInt(255)), console.get(0,0).foreColor, 0.99),
    backColor: new Color.interpolate(new Color(R.nextInt(255),R.nextInt(255),R.nextInt(255)), console.get(0,0).backColor, 0.99)
  );

  console.flush();
  loop();
}