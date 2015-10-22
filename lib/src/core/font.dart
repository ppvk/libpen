part of libpen;

/// the default font that comes with libpen.
final defaultFont = new Font(new ImageElement(src: 'packages/libpen/font.png'), 16, 16);

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
  
  List chars = [];// stores the chars
  int char_width;
  int char_height;

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
      this.char_width = font.width ~/ chars_horizontal;
      this.char_height = font.height ~/ chars_vertical;
      int iw = 0;
      int ih = 0;
      List trans = [];
      for (int i = chars_horizontal * chars_vertical; i >= 0; i--) {
        if (iw >= chars_horizontal) {
          iw = 0;
          ih++;
        }
        CanvasElement glyph = new CanvasElement();
        glyph
            ..width = char_width
            ..height = char_height
            ..context2D.imageSmoothingEnabled = false
            ..context2D.drawImageScaledFromSource(font, char_width * iw, char_height * ih, char_width, char_height, 0, 0, glyph.width, glyph.height);
        ImageData pixels = glyph.context2D.getImageData(0, 0, char_width, char_height);
        // set transparency from the first glyph
        if (i == chars_horizontal * chars_vertical) trans = [pixels.data[0], pixels.data[1], pixels.data[2]];
        for (var i = 0; i < (pixels.data.length); i += 4) {
          if (pixels.data[i] == trans[0] && pixels.data[i + 1] == trans[1] && pixels.data[i + 2] == trans[2]) pixels.data[i + 3] = 0;

        }
        glyph.context2D.putImageData(pixels, 0, 0, 0, 0, glyph.width, glyph.height);
        chars.add(glyph);
        iw++;
      }
      ready = true;
      loadingComplete.complete(true);
    });
    loaded = loadingComplete.future;
  }
}
