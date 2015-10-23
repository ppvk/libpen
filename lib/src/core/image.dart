part of libpen;

/**
 *  An array of [Glyph]/[Color] data that is easily blitted to an [Image] or [Console].
 *  TODO: make this poolable
 */
class Image {
  Array2D<Char> _charData;

  Image(int width, int height, [Color fore, Color back]) {
    if (fore == null) fore = Color.DEFAULT_FOREGROUND_COLOR;
    _charData = new Array2D.generated(width, height, () => new Char(0, Color.DEFAULT_FOREGROUND_COLOR, Color.DEFAULT_BACKGROUND_COLOR));
  }

  /**
   * Creates an [Image] using a subset of another [Image].
   *
   * This is useful if you use a large hidden [Image] as the map
   * but only want to display what a 'camera' would see.
   */
  Image.from(Image other, {int top, int left, int bottom, int right}) {
    int width = right - left + 1;
    int height = bottom - top + 1;
    _charData = new Array2D.generated(width, height, () => new Char(0, Color.DEFAULT_FOREGROUND_COLOR, Color.DEFAULT_BACKGROUND_COLOR));

    for (int x = width-1; x>=0 ;x--)
      for (int y = height-1; y>=0 ;y--){
        Char otherChar = other._charData.get(left + x, top + y);
        _charData.set(x, y, otherChar._clone());
      }
  }

  /**
   * Sets all chars to 'space' and colors to their defaults.
   *
   * Changes will not be seen until the [Console] is flushed.
   */
  clear() {
    for (Char char in _charData) char
      ..glyph = 0
      ..foreColor = Color.DEFAULT_FOREGROUND_COLOR
      ..backColor = Color.DEFAULT_BACKGROUND_COLOR;
  }

  //TODO fill the image with a color, glyph, or foreground color.
  fill() {
    for (Char char in _charData) char
      ..glyph = 0
      ..foreColor = Color.DEFAULT_FOREGROUND_COLOR
      ..backColor = Color.DEFAULT_BACKGROUND_COLOR;
  }

  /** 
   * Draws a [String] of text onto the [Image]
   * 
   * If max_length is defined, words that will go past that point
   * will wrap to the next line.
   * 
   */
  drawText(int x, int y, String text, [int max_length = 0]) {
    List words = text.split(' ');
    List<String> lines = [''];

    // Prepares the string into a list of shortened lines.
    int currline = 0;
    for (String word in words) {
      while (max_length != 0 && (lines[currline] + word).length > max_length) {
        lines[currline].trim();
        currline++;
        lines.add('');
      }
      lines[currline] += '$word ';
    }

    // Draws those lines onto the Console.
    int xi = 0;
    int yi = 0;
    for (String l in lines) {
      l = l.trim();
      for (int rune in l.runes) {
        setGlyph(x + xi, y + yi, rune);
        xi++;
      }
      yi += 1;
      xi = 0;
    }
  }

  /** 
   * Draws an [Image] onto an [Image] at x and y.
   * Out of bounds cells are ignored.
   */
  drawImage(int x, int y, Image image) {
    this._charData;
    int xi = 0;
    int yi = 0;
    for (Char char in image._charData) {
      this.putChar(x + xi, y + yi, char.glyph, char.foreColor, char.backColor);
      xi++;
      if (xi >= image._charData.width) {
        yi++;
        xi = 0;
      }
    }
  }

  /**
   * Change only the background color of a cell
   * 
   */
  setBackground(int x, int y, Color color) {
    if (_charData.size.contains(new Vec(x, y)) == false) return;
    _charData.get(x, y).backColor = color;
  }

  /**
   * Change only the foreground color of a cell
   * 
   */
  setForeground(int x, int y, Color color) {
    if (_charData.size.contains(new Vec(x, y)) == false) return;
    _charData.get(x, y).foreColor = color;
  }

  /**
   * Change only the ASCII code of a cell
   *
   */
  setGlyph(int x, int y, var char) {
    if (_charData.size.contains(new Vec(x, y)) == false) return;
    if (char is String) char = char.runes.first;
    _charData.get(x, y).glyph = char;
  }

  /**
   * Change cell to char and sets it's coloration
   * If no [Color]s are specified, it will use the defaults
   */
  putChar(int x, int y, var char, [Color foreColor, Color backColor]) {
    if (_charData.size.contains(new Vec(x, y)) == false) return;
    if (char is String) char = char.runes.first;

    if (foreColor != null || backColor != null) _charData.get(x, y)
        ..foreColor = foreColor
        ..backColor = backColor;
    _charData.get(x, y)..glyph = char;
  }
}
