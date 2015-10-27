import 'dart:html' as html;
import 'dart:math';

import 'package:libpen/libpen.dart';

Console console;

Random R = new Random();

main() {
  console = new Console(1024 ~/ 16, 768 ~/ 16);
  Compositor compositor = new Compositor(console);

  RootPanel root = compositor.root
    ..image.fill(backColor: Color.MAGENTA);
  html.document.body.append(console.canvas);
  GamePanel game = new GamePanel(1024 ~/ 16, 768 ~/ 16);
  root.append(game);
}

// Examples of custom Panels that do common tasks.


class GamePanel extends Panel {
  World world = new World();
  GamePanel(int width, int height) : super(width, height) {
    Room room = new Room(100, 100);
    world.currentRoom = room;

    room.map.forEach((Tile tile) {
      tile.backColor = new Color.interpolate(Color.CELADON, Color.BLACK, new Random().nextDouble()/4);
    });

    image = world.render(width, height);

    Keyboard keys = Keyboard.sharedInstance();
    // left
    keys.onKeyDown(37, () {
      world.camera = new Point(world.camera.x-1, world.camera.y);
      image = world.render(width, height);
    });
    // right
    keys.onKeyDown(39, () {
      world.camera = new Point(world.camera.x+1, world.camera.y);
      image = world.render(width, height);
    });
    // up
    keys.onKeyDown(40, () {
      world.camera = new Point(world.camera.x, world.camera.y+1);
      image = world.render(width, height);
    });
    // down
    keys.onKeyDown(38, () {
      world.camera = new Point(world.camera.x, world.camera.y-1);
      image = world.render(width, height);
    });

  }
}



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