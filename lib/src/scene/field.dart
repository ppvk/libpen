part of gui;




class ScrollField extends Field {
  Field _proxy;
  Image _chrome;

  @override get children => _proxy.children;
  @override append(Field other) => _proxy.append(other);
  @override remove(Field other) => _proxy.remove(other);


  ScrollField(width, height) : super(width, height) {
    _proxy = new Field(width - 1, height);
    image = new Image(width, height)
      ..drawText(width - 1, 0, '+')
      ..drawText(width - 1, height - 1, '-');
    _children.add(_proxy);
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
  get children => _children.toList(growable: false);
  append(Field other) {
    _children.add(other);
  }
  remove(Field other) {
    _children.remove(other);
  }
}


