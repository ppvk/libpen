part of libpen;

class Grid<E>{
  List<List<E>> _data;
  Rectangle _rectangle;
  Point _reusablePoint;
  int width;
  int height;
  int left;
  int top;
  
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
  
  Grid(this.left, this.top, this.width, this.height,[var fill]){// This should give us something that functions like a 2D array. 
    _reusablePoint = new Point(0,0); 
    _rectangle = new Rectangle(left, top, width, height);
    _data = new List.generate(width,(_) => new List.generate(height,(_) => fill));
  }
  
  bool containsCell(int x,int y) => _rectangle.containsPoint(new Point(x,y));
  bool containsGrid(Grid another)=> _rectangle.containsRectangle(another._rectangle);
  
}


