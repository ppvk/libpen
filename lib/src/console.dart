part of libpen;

/// A representation of a text-based console.
class Console extends Image {
  DivElement container;
  CanvasElement _foreCanvas;
  CanvasElement _backCanvas;
  Font font;
  int x_in_chars;
  int y_in_chars;


  Console(int width, int height, [Font font]) : super(width, height) {
    if (font == null) this.font = defaultFont; else this.font = font;

    container = new DivElement()..classes.add('libpen-console');
    _foreCanvas = new CanvasElement()..context2D.imageSmoothingEnabled = false;
    _backCanvas = new CanvasElement()..context2D.imageSmoothingEnabled = false;

    container
        ..append(_backCanvas)
        ..append(_foreCanvas);

    _consoleListeners(this);

    // once the font is loaded we'll use it to scale our canvas.
    this.font.loaded.then((_) {
      _foreCanvas
          ..style.position = 'absolute'
          ..style.top = '0'
          ..style.left = '0'
          ..style.margin = '0'
          ..width = charData.width * this.font.char_width
          ..height = charData.height * this.font.char_height;
      _backCanvas
          ..style.position = 'absolute'
          ..style.top = '0'
          ..style.left = '0'
          ..style.margin = '0'
          ..width = charData.width * this.font.char_width
          ..height = charData.height * this.font.char_height;
    });
  }

  /**
   * Sets all chars to 'space' and colors to their defaults.
   * 
   * Changes will not be seen until the [Console] is flushed.
   */
  clear() {
    for (Char char in charData) char
        ..glyph = 0
        ..foreColor = Char.DEFAULT_FOREGROUND_COLOR
        ..backColor = Char.DEFAULT_BACKGROUND_COLOR;
  }

  /// Pushes the character data to the Canvas. Refreshes the screen.
  flush() {
    font.loaded.then((_) {

      // request a frame.
      window.requestAnimationFrame((frame) {

        // for each cell in the grid draw the cell
        for (int x = charData.width - 1; x >= 0; x--) {
          for (int y = charData.height - 1; y >= 0; y--) {

            // prepare foreground
            font.chars[charData.get(x, y).glyph].context2D
                ..fillStyle = charData.get(x, y).foreColor.toString()
                ..globalCompositeOperation = 'source-in'
                ..fillRect(0, 0, font.char_width, font.char_height);

            // print background but only if there was a change
            _backCanvas.context2D
                ..fillStyle = charData.get(x, y).backColor.toString()
                ..fillRect(x * font.char_width, y * font.char_height, font.char_width, font.char_height);

            // print foreground, but only if there was a change
            _foreCanvas.context2D
                ..clearRect(x * font.char_width, y * font.char_height, font.char_width, font.char_height)
                ..drawImageScaled(
                    font.chars[charData.get(x, y).glyph],
                    x * font.char_width,
                    y * font.char_height,
                    font.char_width,
                    font.char_height);
          }
        }
      });
    });
  }
}
