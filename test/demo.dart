import 'dart:html' as html;
import 'dart:math';

import 'package:libpen/console.dart';
import 'package:libpen/gui.dart';

Console console;

Random R = new Random();

main() {
  Root root = new Root(40,40);
  html.document.body.append(root.console.canvas);


  WindowField window = new WindowField(38, 15)
    ..x = 1
    ..y = 1
    ..image.fill(backColor: Color.GRAY);



  ScrollField scroll = new ScrollField(38, 14)
    ..image.fill(backColor: Color.GRAY);

  TextField textField = new TextField(37, 70, 'X');
  for (int i = textField.image.height - 1; i>=0 ; i-- ) {
    textField.image
      ..fill(backColor: Color.WHITE, foreColor: Color.BLACK)
      ..drawText(0, i, i.toString());
  }

  ButtonField closeButton = new ButtonField(1,1,'x', () {
    window.parent.remove(window);
    print('closed!');
  })
    ..x = window.width - 1
    ..image.setBackground(0,0, Color.GRAY);
  window.append(closeButton);

  root.append(window);
  window.body.append(scroll);
  scroll.body.append(textField);
}
