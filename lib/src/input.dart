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
String cursor = 'default';
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

_consoleListeners(Console console) {
// make sure font is loaded by now.
console.font.loaded.then((_) {
  // Handle Right Clicks
  console.container.onContextMenu.listen((MouseEvent m) {
    _mouse._onRightClick.add({
      'cell': new Point((m.client.x + console.container.client.left) ~/ console.font.char_width, (m.client.y + console.container.client.top) ~/ console.font.char_height),
      'shift': m.shiftKey,
      'alt': m.altKey,
      'console': console
    });
    m.preventDefault();
  });

  // Handle Normal Clicks
  console.container.onClick.listen((MouseEvent m) {
    _mouse._onClick.add({
      'cell': new Point(m.client.x ~/ console.font.char_width, m.client.y ~/ console.font.char_height),
      'shift': m.shiftKey,
      'alt': m.altKey,
      'console': console
    });
    m.preventDefault();
  });
  console.container.onDoubleClick.listen((MouseEvent m) {
    _mouse._onDoubleClick.add({
      'cell': new Point(m.client.x ~/ console.font.char_width, m.client.y ~/ console.font.char_height),
      'shift': m.shiftKey,
      'alt': m.altKey,
      'console': console
    });
    m.preventDefault();
  });
});
}
