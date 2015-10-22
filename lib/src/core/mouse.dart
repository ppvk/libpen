part of libpen;

/**
 * A representation of a user's pointing mechanism.
 * 
 * Only registers events when the target is a Console. 
 */
class Mouse {
  //Reusable mouse object.
  static Mouse _mouse;

  StyleElement _mouseStyle;

  /// The cursor's style, can be any string assignable to the CSS property 'cursor'.
  String cursor = 'default';

  /// The cursor's visibility.
  bool hidden = false;

  StreamController _onClick = new StreamController();
  StreamController _onRightClick = new StreamController();
  StreamController _onDoubleClick = new StreamController();
  StreamController _onMiddleClick = new StreamController();
  StreamController _onWheelUp = new StreamController();
  StreamController _onWheelDown = new StreamController();

  Stream get onClick => _onClick.stream;
  Stream get onRightClick => _onRightClick.stream;
  Stream get onDoubleClick => _onDoubleClick.stream;
  Stream get onMiddleClick => _onMiddleClick.stream;
  Stream get onWheelUp => _onWheelUp.stream;
  Stream get onWheelDown => _onWheelDown.stream;

  Mouse._new();

  static Mouse sharedInstance() {
    if (_mouse == null) {
      _mouse = new Mouse._new();
      _mouse._mouseStyle = new StyleElement();
      document.head.append(_mouse._mouseStyle);
    }
    return _mouse;
  }


  hide() {
    hidden = true;
    _mouseStyle.text = '.libpen-console{cursor:none;}';
  }

  show() {
    hidden = false;
    _mouseStyle.text = '.libpen-console{cursor:' + cursor + ';}';
  }
}

// sets up event listeners for a Console
_consoleListeners(Console console) {
// make sure font is loaded by now.
  console.font.loaded.then((_) {
    // Handle Right Clicks
    console.container.onContextMenu.listen((MouseEvent m) {
      Rectangle containerRect = console.container.getBoundingClientRect();
      Mouse.sharedInstance()._onRightClick.add(new ClickEvent(
          new Point(
              (m.client.x - containerRect.left) ~/ console.font.char_width,
              (m.client.y - containerRect.top) ~/ console.font.char_height),
          m.shiftKey,
          m.altKey,
          console));
      m.preventDefault();
    });

    // Handle Normal Clicks
    console.container.onClick.listen((MouseEvent m) {
      Rectangle containerRect = console.container.getBoundingClientRect();
      Mouse.sharedInstance()._onClick.add(new ClickEvent(
          new Point(
              (m.client.x - containerRect.left) ~/ console.font.char_width,
              (m.client.y - containerRect.top) ~/ console.font.char_height),
          m.shiftKey,
          m.altKey,
          console));
      m.preventDefault();
    });

    // Handle Double Clicks
    console.container.onDoubleClick.listen((MouseEvent m) {
      Rectangle containerRect = console.container.getBoundingClientRect();
      Mouse.sharedInstance()._onDoubleClick.add(new ClickEvent(
          new Point(
              (m.client.x - containerRect.left) ~/ console.font.char_width,
              (m.client.y - containerRect.top) ~/ console.font.char_height),
          m.shiftKey,
          m.altKey,
          console));
      m.preventDefault();
    });
  });
}

class ClickEvent {
  Point char;
  bool shift;
  bool alt;
  Console console;

  ClickEvent(final this.char, final this.shift, final this.alt, final this.console);

  @override
  String toString() {
    return 'x:${char.x}, y:${char.y}, shift:$shift, alt:$alt, Console id ${console.hashCode}';
  }
}
