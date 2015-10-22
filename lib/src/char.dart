part of libpen;


class Char {
  // Default Color Declaration;
  static final DEFAULT_FOREGROUND_COLOR = Color.WHITE;
  static final DEFAULT_BACKGROUND_COLOR = Color.BLACK;

  int glyph;
  List<String> flags = [];
  Color foreColor,backColor;

  Char(this.glyph, this.foreColor, this.backColor,{this.flags});

  Char clone() {
    return new Char(glyph, foreColor, backColor, flags: flags);
  }
}