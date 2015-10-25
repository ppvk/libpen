import 'dart:html' as html;
import 'dart:math';

import 'package:libpen/console.dart';
//import 'package:libpen/gui.dart';

Console console;

Random R = new Random();

main() {
  console = new Console(50,50);
  html.document.body.append(console.canvas);
  loop();

  console.mouse.onClick.listen((e) => print(e));
}

loop() async {
  await html.window.animationFrame;

  console.fill(glyph: R.nextInt(60),
    foreColor:new Color(R.nextInt(60),R.nextInt(60),R.nextInt(60)),
    backColor: new Color(R.nextInt(60),R.nextInt(60),R.nextInt(60))
  );

  console.flush();
  loop();
}