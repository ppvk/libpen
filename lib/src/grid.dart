part of libpen;

class Grid<E>{
  List<List<E>> _data;
  Rectangle _rectangle;
  Point _reusablePoint;
  
  get width => _rectangle.width;
  get height => _rectangle.height;
  get top => _rectangle.top;
  get left => _rectangle.left;
  
  
  operator [](int x) => _data[x];
  
  void fill(var value){
    for (List col in _data){// for each column in each row.
      for (var v in col){ // for each value in each column.
        col[col.indexOf(v)] = value;
      }
   }
  }
  void forEach(Function f){
    int x = 0;
    int y = 0;
    for (List col in _data){// for each column in each row.
      for (var value in col){ // for each value in each column.
        f(x,y,value);
        x++;
      }
      x=0;
      y++;
    }
  }
  
  Grid(int left, int top, int width, int height,[var fill]){// This should give us something that functions like a 2D array. 
    _reusablePoint = new Point(0,0); 
    _rectangle = new Rectangle(left, top, width-1, height-1);
    _data = new List.generate(width,(_) => new List.generate(height,(_) => fill));
  }
  
  factory Grid.from(Grid other) {
    Grid newGrid = new Grid(other.left,other.top,other.width,other.height);
    other.forEach((int x, int y, var value) {
      newGrid[x][y] = value;
    });
    return newGrid;
  }
  
  bool containsCell(int x,int y) => _rectangle.containsPoint(new Point(x,y));  
}


