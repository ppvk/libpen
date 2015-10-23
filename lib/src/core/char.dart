part of libpen;

// TODO make poolable.
/// [Char]s represent a cell of an [Image] or [Terminal]. *
class Char {
  // _dirty is a flag that tells the console this cell needs to be updated.
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

  // Chars do not have a default constructor, because the end user shouldn't be creating them.
  Char._(this._glyph, this._foreColor, this._backColor);

  Char _clone() {
    return new Char._(glyph, foreColor, backColor);
  }
}