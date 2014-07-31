import 'package:libpen/libpen.dart';
import 'package:libpen/libpen_mouse.dart';

Color playercolor = new Color(166, 39, 6);

main() {
  Mouse mouse = new Mouse();


    Console root = new Console(50,30);
    root.drawText(5, 5, "Once upon a time, there were seven little folk.", 20);
    mouse.onClick.listen((Map event) {print(event);});
    root.flush();

}