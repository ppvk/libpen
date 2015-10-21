part of libpen;


class Char {
  // Default Color Declaration;
  static final DEFAULT_FOREGROUND_COLOR = Color.WHITE;
  static final DEFAULT_BACKGROUND_COLOR = Color.BLACK;

  int glyph;
  Color foreColor,backColor;
  Char(this.glyph, this.foreColor, this.backColor); 
}