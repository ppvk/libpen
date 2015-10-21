part of libpen;


class Cell {
  int glyph;
  List<String> flags = [];
  Color foreColor,backColor;

  Cell(this.glyph, this.foreColor, this.backColor,{this.flags});

  Cell clone() {
    return new Cell(glyph, foreColor, backColor, flags: flags);
  }
}