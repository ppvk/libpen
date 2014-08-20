part of libpen;


// Default Color Declaration;
Color defaultBackground = BLACK;
Color defaultForeground = WHITE;


/**
 * Handles default colors and manipulation
 * 
 * 
 */ 
class Color {
  /// Red color value
  int r;
  /// Green color value
  int g;
  /// Blue color Value
  int b;
  /// Alpha channel
  int a;
  /// Mulitplies two colors together.
  Color operator *(Color other) {
    int nr = r * other.r ~/ 255;
    int ng = g * other.g ~/ 255;
    int nb = b * other.b ~/ 255;
    return new Color(nr, ng, nb);
  }
  /// Adds two colors together.
  Color operator +(Color other) {
    int nr = min(255, r + other.r);
    int ng = min(255, g + other.g);
    int nb = min(255, b + other.b);
    return new Color(nr, ng, nb);
  }
  /// Subtracts one color from another.
  Color operator -(Color other) {
    int nr = max(0, r - other.r);
    int ng = max(0, g - other.g);
    int nb = max(0, b - other.b);
    return new Color(nr, ng, nb);
  }
  /// tests if this Color is the same as another Color.
  bool operator ==(Color other) {
    if (this.hashCode == other.hashCode) return true; else return false;
  }
  @override
  /// Returns rgba as an appended integer.
  get hashCode => int.parse('$r$g$b$a');

  String toString() {
    return 'rgba(' + r.toString() + ',' + g.toString() + ',' + b.toString() + ',' + a.toString() + ')';
  }
  /// A representation of color in rgb format.
  Color(this.r, this.g, this.b, [this.a = 255]);
  Color.interpolate(Color c1, Color c2, num coef) {
    this.r = (c1.r + (c2.r - c1.r) * coef).toInt();
    this.g = (c1.g + (c2.g - c1.g) * coef).toInt();
    this.b = (c1.b + (c2.b - c1.b) * coef).toInt();
    this.a = 255;
  }
}


// DEFAULT COLORS
final Color BLACK = new Color(0, 0, 0);
final Color GREY = new Color(127, 127, 127);
final Color SEPIA = new Color(127, 101, 63);
final Color WHITE = new Color(255, 255, 255);
final Color TRANSPARENT = new Color(0,0,0,0);

final Color BRASS = new Color(191, 151, 96);
final Color COPPER = new Color(196, 136, 124);
final Color GOLD = new Color(229, 191, 0);
final Color SILVER = new Color(203, 203, 203);

final Color CELADON = new Color(172, 255, 175);
final Color PEACH = new Color(255, 159, 127);

final Color RED = new Color(255, 0, 0);
final Color FLAME = new Color(255, 63, 0);
final Color ORANGE = new Color(255, 127, 0);
final Color AMBER = new Color(255, 191, 0);
final Color YELLOW = new Color(255, 255, 0);
final Color LIME = new Color(191, 255, 0);
final Color CHARTREUSE = new Color(127, 255, 0);
final Color GREEN = new Color(0, 255, 0);
final Color SEA = new Color(0, 255, 127);
final Color TURQUOISE = new Color(0, 255, 191);
final Color CYAN = new Color(0, 255, 255);
final Color SKY = new Color(0, 191, 255);
final Color AZURE = new Color(0, 127, 255);
final Color BLUE = new Color(0, 0, 255);
final Color HAN = new Color(63, 0, 255);
final Color VIOLET = new Color(127, 0, 255);
final Color PURPLE = new Color(191, 0, 255);
final Color FUCHSIA = new Color(255, 0, 255);
final Color MAGENTA = new Color(255, 0, 191);
final Color PINK = new Color(255, 0, 127);
final Color CRIMSON = new Color(255, 0, 63);


// COLOR CHANGE FLAGS
final NONE = new Object();
final SET = new Object();
final MULTIPLY = new Object();
final LIGHTEN = new Object();
final DARKEN = new Object();
final SCREEN = new Object();
final COLOR_DODGE = new Object();
final COLOR_BURN = new Object();
final ADD = new Object();
final ADDALPHA = new Object();
final BURN = new Object();
final OVERLAY = new Object();
final ALPHA = new Object();
final DEFAULT = new Object();
