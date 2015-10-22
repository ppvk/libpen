part of libpen;

/**
 *  An array of [Glyph]/[Color] data that is easily blitted to an [Image] or [Console].
 *  TODO: make this poolable
 */
class Image {
  Array2D<Char> charData;

  Image(int width, int height, [Color fore, Color back]) {
    if (fore == null) fore = defaultForeground;
    charData = new Array2D.generated(width, height, () => new Char(0, defaultForeground, defaultBackground));
  }

  Image.from(Image other, {int top, int left, int bottom, int right}) {
    int width = right - left + 1;
    int height = bottom - top + 1;
    charData = new Array2D.generated(width, height, () => new Char(0, defaultForeground, defaultBackground));

    for (int x = width-1; x>=0 ;x--)
      for (int y = height-1; y>=0 ;y--){
        Char otherChar = other.charData.get(left + x, top + y);
        charData.set(x, y, otherChar.clone());
      }
  }

  /**
   * Sets all chars to 'space' and colors to their defaults.
   *
   * Changes will not be seen until the [Console] is flushed.
   */
  clear() {
    for (Char char in charData) char
      ..glyph = 0
      ..foreColor = defaultForeground
      ..backColor = defaultBackground;
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
        setChar(x + xi, y + yi, rune);
        xi++;
      }
      yi += 1;
      xi = 0;
    }
  }

  /** 
   * Draws an [Image] of onto an [Image] at x and y.
   * 
   */
  drawImage(int x, int y, Image image) {
    this.charData;
    int xi = 0;
    int yi = 0;
    for (Char char in image.charData) {
      this.putChar(x + xi, y + yi, char.glyph, char.foreColor, char.backColor);
      xi++;
      if (xi >= image.charData.width) {
        yi++;
        xi = 0;
      }
    }
  }

  /**
   * Change only the background color of a cell
   * 
   */
  setCharBackground(int x, int y, Color color, [var flag]) {
    if (charData.size.contains(new Vec(x, y)) == false) return;
    // Do nothing
    //if (flag.hashCode == NONE.hashCode);
    // Set the Color
    //else if (flag.hashCode == SET.hashCode || flag == null) {
    charData.get(x, y).backColor = color;
    //}
    // TODO implement other color manipulations
  }

  /**
   * Change only the foreground color of a cell
   * 
   */
  setCharForeground(int x, int y, Color color, [var flag]) {
    if (charData.size.contains(new Vec(x, y)) == false) return;
    charData.get(x, y).foreColor = color;
    // TODO implement other color manipulations
  }
  /**
   * Change only the ASCII code of a cell
   * 
   */
  setChar(int x, int y, var char) {
    if (charData.size.contains(new Vec(x, y)) == false) return;
    if (char is String) char = char.runes.first;
    charData.get(x, y).glyph = char;
  }

  /**
   * Change cell to char and sets it's coloration
   * If no [Color]s are specified, it will use the defaults
   */
  putChar(int x, int y, var char, [Color foreColor, Color backColor]) {
    if (charData.size.contains(new Vec(x, y)) == false) return;
    if (char is String) char = char.runes.first;

    if (foreColor != null || backColor != null) charData.get(x, y)
        ..foreColor = foreColor
        ..backColor = backColor;
    charData.get(x, y)..glyph = char;
  }
}
