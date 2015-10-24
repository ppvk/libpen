part of libpen;

/// A representation of a text-based console.
class Console extends Image {
  CanvasElement container;
  Font font;
  int x_in_chars;
  int y_in_chars;

  Mouse mouse;

  Console(int width, int height, [Font font]) : super(width, height) {
    if (font == null) this.font = defaultFont;
    else this.font = font;

    container = new CanvasElement()
      ..classes.add('libpen-console')
      ..classes.add('console-${hashCode}')
      ..context2D.imageSmoothingEnabled = false;

    mouse = new Mouse._(this);

    // once the font is loaded we'll use it to scale our canvas.
    this.font.loaded.then((_) {
      container
        ..width = _charData.width * this.font.char_width
        ..height = _charData.height * this.font.char_height;
    });
  }

  /// Pushes the character data to the Canvas. Refreshes the screen.
  flush() {
    font.loaded.then((_) {
      // for each cell in the grid draw the cell
      for (int x = _charData.width - 1; x >= 0; x--) {
        for (int y = _charData.height - 1; y >= 0; y--) {
          if (_charData.get(x, y)._dirty) {
            _charData.get(x, y)._dirty = false;
            // prepare foreground
            font.chars[_charData.get(x, y).glyph].context2D
              ..fillStyle = _charData.get(x, y).foreColor.toString()
              ..globalCompositeOperation = 'source-in'
              ..fillRect(0, 0, font.char_width, font.char_height);

            // print background but only if there was a change
            container.context2D
              ..clearRect(x * font.char_width, y * font.char_height,
                  font.char_width, font.char_height)
              ..fillStyle = _charData.get(x, y).backColor.toString()
              ..fillRect(x * font.char_width, y * font.char_height,
                  font.char_width, font.char_height);

            // print foreground, but only if there was a change
            container.context2D
              ..drawImageScaled(
                  font.chars[_charData.get(x, y).glyph],
                  x * font.char_width,
                  y * font.char_height,
                  font.char_width,
                  font.char_height);
          }
        }
      }
    });
  }
}
