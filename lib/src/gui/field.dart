part of libpen.gui;

class ScrollField extends Field {
  Field _proxy;
  @override get children => _proxy.children;
  @override append(Field other) => _proxy.append(other);
  @override remove(Field other) => _proxy.remove(other);

  Root root;

  ScrollField(width, height) : super(width, height) {
    _proxy = new Field(width - 1, height);
    image = new Image(width, height)
      ..setGlyph(width - 1, 0, 30)
      ..setGlyph(width - 1, height - 1, 31);

    for (int i = height-1; i>=0 ; i--) {
      image.setBackground(width - 1, i, new Color.interpolate(
          image.get(width - 1, i).backColor,
          image.get(width - 1, i).foreColor,
          0.2
        )
      );
    }
    _children.add(_proxy);
  }

  @override
  handleClick(ClickEvent c) {
    if (c.position == new Point(x + width, y + 1)) {
      for (Field child in children)
        child.y += 1;
    }
    if (c.position == new Point(x + width, y + height)) {
      for (Field child in children)
        child.y -= 1;
    }
  }

}


class Root extends Field {
  Console console;
  Root(width, height) : super(width, height) {
    console = new Console(width, height);

    // pass clicks to children
    Mouse.onClick.listen((ClickEvent e) {
      for (Field child in children) {
        child.handleClick(e);
      }
    });

    update();
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
        child.setRoot(root);
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

  handleClick(ClickEvent c) {
    // nothing by default
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