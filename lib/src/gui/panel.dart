part of libpen.gui;

/**
 * The [Compositor] handles [Panel] positions and layering,
 * drawing the updates to the [Console] when needed.
 */

class Compositor {
  RootPanel root;
  Console console;
  Compositor(final this.console) {
    root = new RootPanel._(console.width, console.height, console);
    _update();
  }

  _update() {
    html.window.requestAnimationFrame((_) {
      console.drawImage(0, 0, root.render());
      console.flush();
      _update();
    });
  }

}



/**
 * A [RootPanel] is a special [Panel] that wraps a [Console].
 * It's a lot like the 'document' object in HTML
 */
class RootPanel extends Panel {
  Console _console;
  RootPanel._(width, height, this._console) : super(width, height) {
    // pass clicks to children
    _console.mouse.onClick.listen((pos) {
      _handleClick(pos);
    });
  }
}



/**
 * A [Field] is a rectangular field of characters that can be
 * moved, nested, and layered atop each other.
 */
class Panel {
  List<Panel> _children = [];
  int x = 0;
  int y = 0;
  int width, height;
  Image image;

  Panel(this.width, this.height) {
    image = new Image(width, height);
  }

  Image render([int depth = 0]) {
    Image output = new Image(width, height);
    output.drawImage(0, 0, image);

    // recursive rendering
    if (_children.isNotEmpty) {
      if (depth > 64) return output;
      _children.forEach((Panel child) {
        Image childImage = child.render(depth + 1);
        output.drawImage(child.x, child.y, childImage);
      });
    }
    return output;
  }


  StreamController _onClick = new StreamController.broadcast();
  /// A Stream that is updated when the [Panel] is clicked.
  Stream get onClick => _onClick.stream;

  _handleClick(Point pos) {
    _onClick.add(pos);

    for (Panel child in children) {
      if (new Rectangle(child.offset.x, child.offset.y, child.width - 1, child.height - 1)
          .containsPoint(pos)) {
        child._handleClick(pos);
      }
    }
  }

  /// The position of the panel in [Console] coordinates.
  /// For local coordinates, use the x and y vars.
  Point get offset {
    if (parent == null) return new Point(0, 0);
    return new Point(parent.offset.x + x, parent.offset.y + y);
  }

  // querying, adding, and removing children.

  /// The enclosing [Panel]
  get parent => _parent;
  Panel _parent;

  get children => _children.toList(growable: false);

  /// Embed another [Panel] within this one.
  append(Panel other) {
    if (other is RootPanel) return;
    _children.add(other);
    other._parent = this;
  }

  /// Remove an embedded [Panel] from this one.
  remove(Panel other) {
    _children.remove(other);
    other._parent = null;
  }
}
