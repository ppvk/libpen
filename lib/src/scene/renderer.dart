part of gui;

/**
 * A [Field] is a rectangular field of characters that can be
 * moved, nested, and layered atop each other.
 */
class Field {
  List<Field> children = [];
  int x = 0;
  int y = 0;
  int width,height;
  Image image;

  Field(this.width, this.height);

  Image render() {
    Image output = new Image(width, height);

    if (image != null) {
      output.drawImage(0,0, image);
    }

    // recursive rendering
    if (children.isNotEmpty) {
      children.forEach((Field child) {
        Image childImage = child.render();
        output.drawImage(child.x, child.y, childImage);
      });
    }

    return output;
  }
}


