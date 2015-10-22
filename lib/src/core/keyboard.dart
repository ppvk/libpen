part of libpen;

//TODO apply this strategy to the Mouse object
class Keyboard {
  Map<int, bool> _keyDownMap = new Map<int, bool>();

  static final Keyboard _keyboard = new Keyboard._singleton();

  static Keyboard sharedInstance() => _keyboard;

  Keyboard._singleton() {
    document.onKeyDown.listen((KeyboardEvent keyboardEvent) {
      _keyDownMap[keyboardEvent.keyCode] = true;
    });
    document.onKeyUp.listen((KeyboardEvent keyboardEvent) {
      _keyDownMap[keyboardEvent.keyCode] = false;
    });
  }

  List<StreamSubscription> streamSubscriptions = new List<StreamSubscription>();

  StreamSubscription onKeyDown(int keyCode, Function handleKeyDown) {
    StreamSubscription streamSubscription =
    document.onKeyDown.listen((KeyboardEvent keyboardEvent) {
      if (keyboardEvent.keyCode == keyCode) handleKeyDown();
    });
    streamSubscriptions.add(streamSubscription);
    return streamSubscription;
  }

  StreamSubscription onKeyUp(int keyCode, Function handleKeyUp) {
    StreamSubscription streamSubscription =
    document.onKeyUp.listen((KeyboardEvent keyboardEvent) {
      if (keyboardEvent.keyCode == keyCode) handleKeyUp();
    });
    streamSubscriptions.add(streamSubscription);
    return streamSubscription;
  }

  bool isKeyDown(int keyCode) {
    if (!_keyDownMap.containsKey(keyCode)) return false;
    return _keyDownMap[keyCode];
  }

  void removeAllStreamSubscriptions() {
    streamSubscriptions.forEach(
            (StreamSubscription streamSubscription) => streamSubscription.cancel());
    streamSubscriptions.clear();
  }
}