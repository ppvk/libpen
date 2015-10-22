part of libpen;


class Char {
  int glyph;
  List<String> flags = [];
  Color foreColor,backColor;

  Char(this.glyph, this.foreColor, this.backColor,{this.flags});

  Char clone() {
    return new Char(glyph, foreColor, backColor, flags: flags);
  }
}