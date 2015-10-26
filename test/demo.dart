import 'dart:html' as html;
import 'dart:math';

import 'package:libpen/console.dart';
import 'package:libpen/gui.dart';

Console console;

Random R = new Random();

main() {
  RootPanel root = new RootPanel(1024 ~/ 16, 768 ~/ 16)
    ..image.fill(backColor: Color.MAGENTA);
  html.document.body.append(root.console.canvas);

  WindowField window = new WindowField(38, 15)
    ..x = 1
    ..y = 1
    ..image.fill(backColor: Color.GRAY);

  ScrollPanel scroll = new ScrollPanel(38, 14)
    ..image.fill(backColor: Color.GRAY);

  TextField textField = new TextField(37, 70, 'X');
  for (int i = textField.image.height - 1; i >= 0; i--) {
    textField.image
      ..fill(backColor: Color.WHITE, foreColor: Color.BLACK)
      ..drawText(0, i, i.toString());
  }

  root.append(window);
  window.body.append(scroll);
  scroll.body.append(textField);
}

// Example of custom Panels that do common tasks.

class WindowField extends Panel {
  Panel body;

  WindowField(width, height) : super(width, height) {
    body = new Panel(width, height - 1)..y = 1;
    image = new Image(width, height)..fill(glyph: '=');
    append(body);

    Panel closeButton = new Panel(1, 1)
      ..x = width - 1
      ..image.setBackground(0, 0, Color.GRAY)
      ..image.setGlyph(0, 0, '*')
      ..onClick.listen((_) {
      parent.remove(this);
      print('closed!');
    });
    append(closeButton);
  }
}

class TextField extends Panel {
  String _text;
  get text => _text;
  set text(String text) {
    _text = text;
    image.drawText(0, 0, _text, width);
  }

  TextField(width, height, String text) : super(width, height) {
    image = new Image(width, height);
    this.text = text;
  }
}

class ScrollPanel extends Panel {
  Panel body;

  ScrollPanel(width, height) : super(width, height) {
    body = new Panel(width - 1, height);
    image = new Image(width, height)
      ..setGlyph(width - 1, 0, 30)
      ..setGlyph(width - 1, height - 1, 31);

    Panel upButton = new Panel(1, 1)
      ..x = width - 1
      ..image.setGlyph(0, 0, 30)
      ..onClick.listen((_) {
      for (Panel child in body.children) {
        if (child.y < 0) child.y += 1;
        return;
      }
    });
    append(upButton);

    Panel downButton = new Panel(1, 1)
      ..x = width - 1
      ..y = height - 1
      ..image.setGlyph(0, 0, 31)
      ..onClick.listen((_) {
      for (Panel child in body.children) {
        if (child.y > height - child.height) child.y -= 1;
        return;
      }
    });
    append(downButton);

    super.append(body);
  }
}