part of libpen.console;

/**
 * A representation of a user's pointing mechanism.
 * 
 * Only registers events within the [Console].
 */
class Mouse {
  Console _console;
  Mouse._(this._console) {
    // make sure font is loaded by now.
    // otherwise we will not know how big the cells are.
    _console.font.loaded.then((_) {

      // Handle Right Clicks
      _console.canvas.onContextMenu.listen((MouseEvent m) {
        Rectangle containerRect = _console.canvas.getBoundingClientRect();
        _onRightClick.add(new ClickEvent(
            new Point(
                (m.client.x - containerRect.left) ~/ _console.font.char_width,
                (m.client.y - containerRect.top) ~/ _console.font.char_height),
            m.shiftKey,
            m.altKey));
        m.preventDefault();
      });

      // Handle Normal Clicks
      _console.canvas.onClick.listen((MouseEvent m) {
        Rectangle containerRect = _console.canvas.getBoundingClientRect();
        _onClick.add(new ClickEvent(
            new Point(
                (m.client.x - containerRect.left) ~/ _console.font.char_width,
                (m.client.y - containerRect.top) ~/ _console.font.char_height),
            m.shiftKey,
            m.altKey));
        m.preventDefault();
      });

      // Handle Double Clicks
      _console.canvas.onDoubleClick.listen((MouseEvent m) {
        Rectangle containerRect = _console.canvas.getBoundingClientRect();
        _onDoubleClick.add(new ClickEvent(
            new Point(
                (m.client.x - containerRect.left) ~/ _console.font.char_width,
                (m.client.y - containerRect.top) ~/ _console.font.char_height),
            m.shiftKey,
            m.altKey));
        m.preventDefault();
      });

      // Handle passive mouse position
      _console.canvas.onMouseOver.listen((MouseEvent m) {
        if (_x != m.client.x)
          _x = m.client.x;
        if (_y != m.client.y)
          _y = m.client.y;
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
  StreamController _onWheelUp = new StreamController.broadcast();
  StreamController _onWheelDown = new StreamController.broadcast();

  Stream get onClick => _onClick.stream;
  Stream get onRightClick => _onRightClick.stream;
  Stream get onDoubleClick => _onDoubleClick.stream;
  Stream get onMiddleClick => _onMiddleClick.stream;
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

class ClickEvent {
  Point position;
  bool shift;
  bool alt;

  ClickEvent(final this.position, final this.shift, final this.alt);

  @override
  String toString() {
    return 'x:${position.x}, y:${position.y}, shift:$shift, alt:$alt';
  }
}
