library libpen.game;
import 'dart:math';
import 'console.dart';
import 'package:piecemeal/piecemeal.dart';

class World {
  List<Room> rooms = [];
  Room currentRoom;
  Point camera = new Point(0, 0);

  Image render(int width, int height) {
    int left = (camera.x - width~/2);
    int top = (camera.y - height~/2);

    Image render = new Image(width, height);

    for (int x = width-1; x>=0 ;x--)
      for (int y = height-1; y>=0 ;y--){
        if (left + x >= 0 && top + y >= 0 && left + x <= currentRoom.map.width - 1 && top + y <= currentRoom.map.height - 1) {
          Tile otherTile = currentRoom.map.get(left + x, top + y);
          render.put(x, y, otherTile.glyph, otherTile.foreColor, otherTile.backColor);
        }
      }

    for (Entity entity in currentRoom.entities) {
      if (new Rectangle(left, top, width, height).containsPoint(entity.position)) {
        if (entity.glyph != null) {
          render.setGlyph(entity.position.x - left, entity.position.y - top, entity.glyph);
        }
        if (entity.backColor != null) {
          render.setBackground(entity.position.x - left, entity.position.y - top, entity.backColor);
        }
        if (entity.foreColor != null) {
          render.setForeground(entity.position.x - left, entity.position.y - top, entity.foreColor);
        }
      }
    }

    return render;
  }
}

class Room {
  Array2D<Tile> map;
  List<Entity> entities = [];
  Room(int width, int height) {
    map = new Array2D.generated(width, height, () {
      return new Tile();
    });
  }
}

class Tile {
  int glyph = 0;
  Color backColor = Color.DEFAULT_BACKGROUND_COLOR;
  Color foreColor = Color.DEFAULT_FOREGROUND_COLOR;
}

class Entity {
  Point position = new Point(0, 0);
  int glyph;
  Color backColor;
  Color foreColor;
}