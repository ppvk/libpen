@TestOn("browser")
import 'dart:html' as html;

import 'package:libpen/console.dart';
import 'package:libpen/gui.dart';

import "package:test/test.dart";

main() {

  group("Color", () {
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

    // TODO muliplication test

    test("interpolation", () {
      Color A = new Color(0,0,0);
      Color B = new Color(100,100,100);
      expect(new Color.interpolate(A,B, 0.5), equals(new Color(50,50,50)));
    });

  });


  group("Image", () {
    Image image;

    test("creation", () {
      image = new Image(10,20);
      expect(image.height.runtimeType, equals(int));
      expect(image.width.runtimeType, equals(int));
    });


    test("dimensions", () {
      expect(image.width, equals(10));
      expect(image.height, equals(20));
    });

    test("get", () {
      var center = image.get(5,5);
      expect(center.runtimeType, equals(Char));
      expect(center.glyph.runtimeType, equals(int));
      expect(center.backColor.runtimeType, equals(Color));
      expect(center.foreColor.runtimeType, equals(Color));
    });

    test("default colors", () {
      Char center = image.get(5,5);
      expect(center.foreColor, equals(Color.DEFAULT_FOREGROUND_COLOR));
      expect(center.backColor, equals(Color.DEFAULT_BACKGROUND_COLOR));
    });

    test("put", () {
      image.put(0,0, 1, Color.GREEN, Color.RED);
      Char origin = image.get(0,0);
      expect(origin.glyph, equals(1));
      expect(origin.foreColor, equals(Color.GREEN));
      expect(origin.backColor, equals(Color.RED));
    });

    test("fill", () {
      image.fill(glyph: 1, foreColor: Color.BLUE, backColor: Color.RED);
      Char center = image.get(5,5);
      expect(center.glyph, equals(1));
      expect(center.foreColor, equals(Color.BLUE));
      expect(center.backColor, equals(Color.RED));
    });

    test("clear", () {
      image.clear();

      Char center = image.get(5,5);
      expect(center.glyph, equals(0));
      expect(center.foreColor, equals(Color.DEFAULT_FOREGROUND_COLOR));
      expect(center.backColor, equals(Color.DEFAULT_BACKGROUND_COLOR));

      Char origin = image.get(0,0);
      expect(origin.glyph, equals(0));
      expect(origin.foreColor, equals(Color.DEFAULT_FOREGROUND_COLOR));
      expect(origin.backColor, equals(Color.DEFAULT_BACKGROUND_COLOR));
    });

  });

}
