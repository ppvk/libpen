part of libpen.gui;


class ButtonField extends TextField{
  Function fn;
  ButtonField(width, height, String text, Function this.fn) : super(width, height, text) {
  }

  @override
  _handleClick(ClickEvent c) {
    fn();
  }
}


class WindowField extends Field {
  Field body;

  WindowField(width, height) : super(width, height) {
    body = new Field(width, height - 1)
      ..y = 1;

    image = new Image(width, height)
      ..fill(glyph: '=');

    super.append(body);
  }

  @override
  _handleClick(ClickEvent c) {
    super._handleClick(c);
  }
}


class TextField extends Field {
  String _text;
  get text => _text;
  set text(String text) {
    _text = text;
    image.drawText(0,0, _text, width);
  }

  TextField(width, height, String text) : super(width, height) {
    image = new Image(width, height);
    this.text = text;
  }
}



class ScrollField extends Field {
  Field body;

  ScrollField(width, height) : super(width, height) {
    body = new Field(width - 1, height);
    image = new Image(width, height)
      ..setGlyph(width - 1, 0, 30)
      ..setGlyph(width - 1, height - 1, 31);

    super.append(body);
  }

  @override
  _handleClick(ClickEvent c) {

    if (c.position == new Point(offset.x + width - 1, offset.y)) {
      for (Field child in body.children) {
        if (child.y < 0)
          child.y += 1;
        return;
      }
    }
    if (c.position == new Point(offset.x + width - 1, offset.y + height - 1)) {
      for (Field child in body.children) {
        if (child.y > height - child.height)
          child.y -= 1;
        return;
      }
    }

    super._handleClick(c);
  }

}


class Root extends Field {
  Console console;
  Root(width, height) : super(width, height) {
    console = new Console(width, height);

    // pass clicks to children
    console.mouse.onClick.listen((ClickEvent e) {
      _handleClick(e);
    });
    _update();
  }

  @override
  append(Field other) {
    super.append(other);
    other._setRoot(this);
  }

  _update() {
    html.window.requestAnimationFrame((_) {
      console.drawImage(x,y, render());
      console.flush();
      _update();
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

  get root => _root;
  Root _root;
  _setRoot(Root root) {
    _root = root;
    for (Field child in children) {
      if (child.root != root)
        child._setRoot(root);
    };
  }

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

  _handleClick(ClickEvent c) {
    for (Field child in children) {
      if (new Rectangle(child.offset.x, child.offset.y, child.width - 1, child.height - 1).containsPoint(new Point(c.position.x, c.position.y))) {
        child._handleClick(c);
      }
    }
  }

  Point get offset {
    if (parent == null)
      return new Point(0,0);
    return new Point(parent.offset.x + x, parent.offset.y + y);
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