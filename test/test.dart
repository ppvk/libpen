@TestOn("browser")
import 'dart:html' as html;

import 'package:libpen/console.dart';
import 'package:libpen/gui.dart';

import "package:test/test.dart";

main() {

  group("Colors", () {

    test("creation via RGBA", () {
      Color testColor = new Color(1,2,3);
      expect(testColor.r, equals(1));
      expect(testColor.g, equals(2));
      expect(testColor.b, equals(3));
    });

    test("equivalence", () {
      Color A = new Color(1,2,3);
      Color B = new Color(1,2,3);
      expect(A, equals(B));
    });

    test("addition", () {
      expect(Color.RED + Color.BLUE, equals(new Color(255,0,255)));
    });

    test("subtraction", () {
      expect(Color.RED + Color.BLUE - Color.RED, equals(Color.BLUE));
    });

    test("interpolation", () {
      Color A = new Color(0,0,0);
      Color B = new Color(100,100,100);
      expect(new Color.interpolate(A,B, 0.5), equals(new Color(50,50,50)));
    });

  });


}
