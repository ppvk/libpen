part of libpen.console;

/**
 * A representation of a user's pointing mechanism.
 * 
 * Only registers events within the [Console].
 */
class Mouse {
  Console _console;

  Rectangle containerRect;

  Mouse._(this._console) {
    // make sure font is loaded by now.
    // otherwise we will not know how big the cells are.
    _console.font.loaded.then((_) {
      containerRect = _console.canvas.getBoundingClientRect();

      // Handle Right Clicks
      _console.canvas.onContextMenu.listen((MouseEvent m) {
        _onRightClick.add(
            new Point(
                (m.client.x - containerRect.left) ~/ _console.font._char_width,
                (m.client.y - containerRect.top) ~/ _console.font._char_height)
        );
        m.preventDefault();
      });

      // Handle Normal Clicks
      _console.canvas.onClick.listen((MouseEvent m) {
        _onClick.add(
            new Point(
                (m.client.x - containerRect.left) ~/ _console.font._char_width,
                (m.client.y - containerRect.top) ~/ _console.font._char_height)
        );
        m.preventDefault();
      });

      // Handle Double Clicks
      _console.canvas.onDoubleClick.listen((MouseEvent m) {
        _onDoubleClick.add(
            new Point(
                (m.client.x - containerRect.left) ~/ _console.font._char_width,
                (m.client.y - containerRect.top) ~/ _console.font._char_height)
        );
        m.preventDefault();
      });

      // Handle passive mouse position and motion.
      _console.canvas.onMouseMove.listen((MouseEvent m) {
        // if the mouse has changed Cells
        if (
          _x != (m.client.x - containerRect.left) ~/ _console.font._char_width
          ||
          _y != (m.client.y - containerRect.top) ~/ _console.font._char_height
        ) {
          _onMouseMove.add(
              new Point(
                  (m.client.x - containerRect.left) ~/ _console.font._char_width,
                  (m.client.y - containerRect.top) ~/ _console.font._char_height)
          );
        }

        if (_x != (m.client.x - containerRect.left) ~/ _console.font._char_width)
          _x = (m.client.x - containerRect.left) ~/ _console.font._char_width;
        if (_y != (m.client.y - containerRect.top) ~/ _console.font._char_height)
          _y = (m.client.y - containerRect.top) ~/ _console.font._char_height;
      });

    });
    show();
  }

  // mouse position getters
  int _x;
  get x => _x;
  int _y;
  get y => _y;

  StyleElement _mouseStyle;
  /// The cursor's style, can be any string assignable to the CSS property 'cursor'.
  String cursor = 'default';
  /// The cursor's visibility.
  bool hidden = false;

  StreamController _onClick = new StreamController.broadcast();
  StreamController _onRightClick = new StreamController.broadcast();
  StreamController _onDoubleClick = new StreamController.broadcast();
  StreamController _onMiddleClick = new StreamController.broadcast();
  StreamController _onMouseMove = new StreamController.broadcast();

  StreamController _onWheelUp = new StreamController.broadcast();
  StreamController _onWheelDown = new StreamController.broadcast();

  Stream get onClick => _onClick.stream;
  Stream get onRightClick => _onRightClick.stream;
  Stream get onDoubleClick => _onDoubleClick.stream;
  Stream get onMiddleClick => _onMiddleClick.stream;
  Stream get onMouseMove => _onMouseMove.stream;

  Stream get onWheelUp => _onWheelUp.stream;
  Stream get onWheelDown => _onWheelDown.stream;

  _addStyleIfAbsent() {
    if (_mouseStyle == null) {
      _mouseStyle = new StyleElement();
      document.head.append(_mouseStyle);
    }
  }

  hide() {
    _addStyleIfAbsent();
    hidden = true;
    _mouseStyle.text = '.console-${_console.hashCode}.libpen-console{cursor:none;}';
  }

  show() {
    _addStyleIfAbsent();
    hidden = false;
    _mouseStyle.text = '.console${_console.hashCode}.libpen-console{cursor:' + cursor + ';}';
  }
}