part of libpen.console;

/// the default font that comes with libpen.
final defaultFont = new Font(new ImageElement(src: 'packages/libpen/font/font.png'), 16, 16);

/**
 * Handles font loading and rendering
 * 
 * Be sure that the 'loaded' future has completed before you let a Console use it.
*/
class Font {
  
  // Sometimes checking a bool is preferred, other times a future.
  // In one case you want to guarantee an action, the other you're willing to skip.
  Future<bool> loaded;
  bool ready = false;
  
  List _chars = [];// stores the positions of the chars
  int _char_width;
  int _char_height;

  CanvasElement _fontCanvas;
  CanvasElement _buffer;

  /** 
   * font can be either an ImageElement OR a valid path as a String. 
   * ImageElements embedded in html are already loaded, shortening your startup time.
   * 
  */
  Font(var font, chars_horizontal, chars_vertical) {
    if (font is String) font = new ImageElement(src: font);

    Completer loadingComplete = new Completer();
    // font is properly loaded
    font.onLoad.listen((_) {
      _char_width = font.width ~/ chars_horizontal;
      _char_height = font.height ~/ chars_vertical;

      _fontCanvas = new CanvasElement()
        ..width = font.width
        ..height = font.height
        ..context2D.imageSmoothingEnabled = false
        ..context2D.drawImage(font, 0, 0);

      // set transparency from the first pixel
      List trans = [];
      ImageData imageData = _fontCanvas.context2D.getImageData(0, 0, _fontCanvas.width, _fontCanvas.height);
      trans = [imageData.data[0], imageData.data[1], imageData.data[2]];
      for (var i = 0; i < (imageData.data.length); i += 4) {
        if (imageData.data[i] == trans[0] && imageData.data[i + 1] == trans[1] && imageData.data[i + 2] == trans[2]) imageData.data[i + 3] = 0;
      }
      _fontCanvas.context2D.putImageData(imageData, 0,0);

      _buffer = new CanvasElement()
        ..width = _char_width
        ..height = _char_height
        ..context2D.imageSmoothingEnabled = false
        ..context2D.drawImage(_fontCanvas, 0, 0);

      int iw = 0;
      int ih = 0;
      for (int i = chars_horizontal * chars_vertical; i >= 0; i--) {
        if (iw >= chars_horizontal) {
          iw = 0;
          ih++;
        }

        Point glyphPos = new Point(_char_width * iw, _char_height * ih);
        _chars.add(glyphPos);
        iw++;
      }
      ready = true;
      loadingComplete.complete(true);
    });
    loaded = loadingComplete.future;
  }
}
