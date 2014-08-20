part of libpen;

//Reusable mouse object.
Mouse _mouse = new Mouse._new();

/**
 * A representation of a user's pointing mechanism.
 * 
 * Only registers events when the target is a Console. 
 */
class Mouse {
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

factory Mouse() {
  if (_mouse != null) return _mouse; else {
    Mouse mouse = new Mouse._new();
    mouse._mouseStyle = new StyleElement();
    document.head.append(mouse._mouseStyle);
    return mouse;
  }
}
// Creates a new Mouse object.
Mouse._new();

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
    _mouse._onRightClick.add(
        new ClickEvent(new Point(m.client.x ~/ console.font.char_width, m.client.y ~/ console.font.char_height),m.shiftKey,m.altKey,console)
    );
    m.preventDefault();
  });

  // Handle Normal Clicks
  console.container.onClick.listen((MouseEvent m) {
    _mouse._onClick.add(
        new ClickEvent(new Point(m.client.x ~/ console.font.char_width, m.client.y ~/ console.font.char_height),m.shiftKey,m.altKey,console)
    );
    m.preventDefault();
  });
  console.container.onDoubleClick.listen((MouseEvent m) {
    _mouse._onDoubleClick.add(
        new ClickEvent(new Point(m.client.x ~/ console.font.char_width, m.client.y ~/ console.font.char_height),m.shiftKey,m.altKey,console));
    m.preventDefault();
  });
});
}


class ClickEvent {
  Point cell;
  bool shift;
  bool alt;
  Console console;  
  ClickEvent(final this.cell,final this.shift,final this.alt,final this.console);
  @override
  String toString() {
    return 'x:${cell.x}, y:${cell.y}, shift:$shift, alt:$alt, Console id ${console.hashCode}';
  }
}



