part of libpen;

//TODO Implement off screen Consoles

/// A representation of a text-based console.
class Console {
  CanvasElement container;
  Grid<List> data;
  Font font;
  int x_in_chars;
  int y_in_chars;
  // Default Color Declaration;
  Color defaultBackground = BLACK;
  Color defaultForeground = WHITE;

  Console(int w_in_chars, int h_in_chars, [Font font]) {
    if (font == null) this.font = defaultFont; else this.font = font;
    
    data = new Grid(0, 0, w_in_chars, h_in_chars,[0,defaultForeground,defaultBackground]);
    container = new CanvasElement()        
      ..classes.add('libpen-console')
      ..context2D.imageSmoothingEnabled = false;
    
    this.font.loaded.then((_) {
      container
        ..width = data.width * this.font.char_width
        ..height = data.height * this.font.char_height;
    });
    
    // initial flush to the screen.
    this.flush();
  }

  /// Pushes the character data to the Canvas. Refreshes the screen.
  flush() {
    // request a frame.
    window.requestAnimationFrame((frame) {

      // for each cell in the grid draw the cell
      data.forEach((int y, int x, List cell) {

        // make sure font is loaded by now.
        font.loaded.then((_) {
          // prepare foreground
          font.chars[cell[0]].context2D
              ..fillStyle = cell[1].toString()
              ..globalCompositeOperation = 'source-in'
              ..fillRect(0, 0, font.char_width, font.char_height);

          // print foreground and background to canvas.
          container.context2D
              ..fillStyle = cell[2] .toString()
              ..fillRect(x * font.char_width, y * font.char_height, font.char_width, font.char_height)
              ..drawImageScaled(font.chars[cell[0]], x * font.char_width, y * font.char_height, font.char_width, font.char_height);
        });
      });
    });
  }

  /**
   * Sets all chars to 'space' and colors to their defaults.
   * 
   * Changes will not be seen until the Console is flushed.
   */
  clear() {
    this.data.fill([0, defaultForeground, defaultBackground]);
  }

  /** 
   * Draws a string of text onto the Console
   * 
   * If max_length is defined, words that will go past that point
   * will wrap to the next line.
   * 
   * Changes will not be seen until the Console is flushed.
   */
  drawText(int x, int y, String text, [int max_length = 0]) {
    List words = text.split(' ');
    List<String> lines = [''];

    int currline = 0;
    for (String word in words) {
      while (max_length != 0 && (lines[currline] + word).length > max_length) {
        lines[currline].trim();
        currline++;
        lines.add('');
      }
      lines[currline] += '$word ';
    }

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
   * Change only the background color of a cell
   * 
   * Changes will not be seen until the Console is flushed.
   */
  setCharBackground(int x, int y, Color color, [var flag]) {
    // Do nothing
    if (flag.hashCode == NONE.hashCode);
    // Set the Color
    else if (flag.hashCode == SET.hashCode || flag == null) {
      data[x][y] = [data[x][y][0], data[x][y][1], color];
    }
    // TODO implement other color manipulations
  }

  /**
   * Change only the foreground color of a cell
   * 
   * Changes will not be seen until the Console is flushed.
   */
  setCharForeground(int x, int y, Color color, [var flag]) {
    data[x][y] = [data[x][y][0], color, data[x][y][2]];
    // TODO implement other color manipulations
  }
  /**
   * Change only the ASCII code of a cell
   * 
   * Changes will not be seen until the Console is flushed.
   */
  setChar(int x, int y, var char) {
    if (data.containsCell(x, y) == true) {
      if (char is String) char = char.runes.first;
      data[x][y] = [char, data[x][y][1], data[x][y][2]];
    }
  }

  /**
   * Change cell to char, using default coloration.
   * 
   * Changes will not be seen until the Console is flushed.
   */
  putChar(int x, int y, var char) {
    if (char is String) char = char.runes.first;
    data[x][y] = [char, defaultForeground, defaultBackground];
  }

  /**
   * Change cell to char and set it's coloration
   * 
   * Changes will not be seen until the Console is flushed.
   */
  putCharEx(int x, int y, var char, Color foreColor, Color backColor) {
    if (char is String) char = char.runes.first;
    data[x][y] = [char, foreColor, backColor];
  }

}