part of libpen;

/// TODO
/// Since we allow the user to have multiple consoles, we should isolate Mouse and Keyboard instances to a particular console.
/// That way clicking on one won't trigger events on the other.

/**
 * A representation of a user's pointing mechanism.
 * 
 * Only registers events when the target is a Console. 
 */
class Mouse {
  static StyleElement _mouseStyle;

  /// The cursor's style, can be any string assignable to the CSS property 'cursor'.
  static String cursor = 'default';

  /// The cursor's visibility.
  static bool hidden = false;

  static StreamController _onClick = new StreamController.broadcast();
  static StreamController _onRightClick = new StreamController.broadcast();
  static StreamController _onDoubleClick = new StreamController.broadcast();
  static StreamController _onMiddleClick = new StreamController.broadcast();
  static StreamController _onWheelUp = new StreamController.broadcast();
  static StreamController _onWheelDown = new StreamController.broadcast();

  static Stream get onClick => _onClick.stream;
  static Stream get onRightClick => _onRightClick.stream;
  static Stream get onDoubleClick => _onDoubleClick.stream;
  static Stream get onMiddleClick => _onMiddleClick.stream;
  static Stream get onWheelUp => _onWheelUp.stream;
  static Stream get onWheelDown => _onWheelDown.stream;

  static _addStyleIfAbsent() {
    if (_mouseStyle == null) {
      _mouseStyle = new StyleElement();
      document.head.append(_mouseStyle);
    }
  }

  static hide() {
    _addStyleIfAbsent();
    hidden = true;
    _mouseStyle.text = '.libpen-console{cursor:none;}';
  }

  static show() {
    _addStyleIfAbsent();
    hidden = false;
    _mouseStyle.text = '.libpen-console{cursor:' + cursor + ';}';
  }
}

//TODO add hover events.

// sets up event listeners for a Console
_consoleListeners(Console console) {
// make sure font is loaded by now.
  console.font.loaded.then((_) {
    // Handle Right Clicks
    console.container.onContextMenu.listen((MouseEvent m) {
      Rectangle containerRect = console.container.getBoundingClientRect();
      Mouse._onRightClick.add(new ClickEvent(
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
      Mouse._onClick.add(new ClickEvent(
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
      Mouse._onDoubleClick.add(new ClickEvent(
          new Point(
              (m.client.x - containerRect.left) ~/ console.font.char_width,
              (m.client.y - containerRect.top) ~/ console.font.char_height),
          m.shiftKey,
          m.altKey,
          console));
      m.preventDefault();
    });
  });
  Mouse.show();
}


class ClickEvent {
  Point position;
  bool shift;
  bool alt;
  Console console;

  ClickEvent(final this.position, final this.shift, final this.alt, final this.console);

  @override
  String toString() {
    return 'x:${position.x}, y:${position.y}, shift:$shift, alt:$alt, Console id ${console.hashCode}';
  }
}
