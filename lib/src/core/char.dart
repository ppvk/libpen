part of libpen;

// TODO make poolable.
class Char {
  // Does this tile need to be updated?
  bool _dirty = true;

  int _glyph;
  get glyph => _glyph;
  set glyph(int glyph) {
    _glyph = glyph;
    _dirty = true;
  }

  Color _foreColor;
  get foreColor => _foreColor;
  set foreColor(Color foreColor) {
    _foreColor = foreColor;
    _dirty = true;
  }

  Color _backColor;
  get backColor => _backColor;
  set backColor(Color backColor) {
    _backColor = backColor;
    _dirty = true;
  }

  Char(this._glyph, this._foreColor, this._backColor);

  Char clone() {
    return new Char(glyph, foreColor, backColor);
  }
}