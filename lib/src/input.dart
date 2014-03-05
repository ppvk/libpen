part of libpen;
// Input

Mouse mouse = new Mouse();
class Mouse{
  StyleElement _mouseStyle;
  String cursor = 'default';
  bool hidden = false;
  

  
  StreamController _onClick = new StreamController();
  StreamController _onRightClick = new StreamController();
  StreamController _onDoubleClick = new StreamController();
  StreamController _onMiddleClick = new StreamController();
  StreamController _onWheelUp = new StreamController();
  StreamController _onWheelDown = new StreamController();
  
  Stream onClick;
  Stream onRightClick;
  Stream onDoubleClick;
  Stream onMiddleClick;
  Stream onWheelUp;
  Stream onWheelDown;
  
  Mouse(){
  _mouseStyle = new StyleElement();
  document.head.append(_mouseStyle);
  
  // Connect our StreamControllers to actual events and pipe them to our streams;
  onClick = _onClick.stream;
  onRightClick = _onRightClick.stream;
  onDoubleClick = _onDoubleClick.stream;
  onMiddleClick = _onMiddleClick.stream;
  onWheelUp = _onWheelUp.stream;
  onWheelDown = _onWheelDown.stream;
  
  
  
  }
  hide(){
    hidden = true;
    _mouseStyle.text = '*{cursor:none;}';
  }
  show(){
    hidden = false;
    _mouseStyle.text = '*{cursor:'+ cursor +';}';
  }
}