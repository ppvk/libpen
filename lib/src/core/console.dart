part of libpen.console;

/// A representation of a text-based console.
class Console extends Image {
  CanvasElement canvas;
  Font font;
  Mouse mouse;

  Console(int width, int height, {this.font, this.canvas}) : super(width, height) {
    if (font == null) font = defaultFont;
    if (canvas == null) canvas = new CanvasElement();

    canvas
      ..classes.add('libpen-console')
      ..classes.add('console-${hashCode}')
      ..context2D.imageSmoothingEnabled = false;

    mouse = new Mouse._(this);

    // once the font is loaded we'll use it to scale our canvas.
    this.font.loaded.then((_) {
      canvas
        ..width = _charData.width * this.font._char_width
        ..height = _charData.height * this.font._char_height;
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
            Point glyphCoords = font._chars[_charData.get(x, y).glyph];

            font._buffer.context2D
              ..globalCompositeOperation = 'source-over'
              ..clearRect(0, 0, font._buffer.width, font._buffer.height)
              ..drawImageScaledFromSource(font._fontCanvas, glyphCoords.x, glyphCoords.y, font._char_width, font._char_height, 0, 0, font._char_width, font._char_height)
              ..fillStyle = _charData.get(x, y).foreColor.toString()
              ..globalCompositeOperation = 'source-in'
              ..fillRect(0, 0, font._char_width, font._char_height);

            // print background but only if there was a change
            canvas.context2D
              ..clearRect(x * font._char_width, y * font._char_height,
                  font._char_width, font._char_height)
              ..fillStyle = _charData.get(x, y).backColor.toString()
              ..fillRect(x * font._char_width, y * font._char_height,
                  font._char_width, font._char_height);

            // print foreground, but only if there was a change
            canvas.context2D
              ..drawImage(font._buffer, x * font._char_width, y * font._char_height);
          }
        }
      }
    });
  }
}
