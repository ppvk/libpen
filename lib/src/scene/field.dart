part of gui;

class Root extends Field {
  Console console;
  Root(width, height) : super(width, height) {
    console = new Console(width, height);
    update();
  }

  update() {
    html.window.requestAnimationFrame((_) {
      console.drawImage(x,y, render());
      console.flush();
      update();
    });
  }
}


class ScrollField extends Field {
  Field _proxy;
  @override get children => _proxy.children;
  @override append(Field other) => _proxy.append(other);
  @override remove(Field other) => _proxy.remove(other);


  ScrollField(width, height) : super(width, height) {
    _proxy = new Field(width - 1, height);
    image = new Image(width, height)
      ..drawText(width - 1, 0, '+')
      ..drawText(width - 1, height - 1, '-');
    _children.add(_proxy);

    Mouse.sharedInstance().onClick.listen((ClickEvent e) {
      if (e.char == new Point(x + width, y + 1)) {
        for (Field child in children)
          child.y += 1;
      }
      if (e.char == new Point(x + width, y + height)) {
        for (Field child in children)
          child.y -= 1;
      }
    });
  }
}


/**
 * A [Field] is a rectangular field of characters that can be
 * moved, nested, and layered atop each other.
 */
class Field {
  List<Field> _children = [];
  int x = 0;
  int y = 0;
  int width,height;
  Image image;

  Field(this.width, this.height);

  Image render([int depth = 0]) {
    Image output = new Image(width, height);

    if (image != null) {
      output.drawImage(0,0, image);
    }

    // recursive rendering
    if (_children.isNotEmpty) {
      if (depth > 64) return output;
      _children.forEach((Field child) {
        Image childImage = child.render(depth + 1);
        output.drawImage(child.x, child.y, childImage);
      });
    }

    return output;
  }

  // querying, adding, and removing children.

  get parent => _parent;
  Field _parent;

  get children => _children.toList(growable: false);

  append(Field other) {
    _children.add(other);
    other._parent = this;
  }
  remove(Field other) {
    _children.remove(other);
    other._parent = null;
  }
}


