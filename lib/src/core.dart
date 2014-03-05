part of libpen;

var _Do = document.onLoad.listen((_){document.documentElement.remove();});

// Core

Console root;
bool _customFont = false;
List _FONT = [];// stores the chars
// Set up the main console
Future initRoot(int w_in_chars, int h_in_chars,[bool fullscreen = false]){
  root = new Console(0,0,w_in_chars,h_in_chars);

  // HTML mods
  document.head
    ..appendHtml(
        '''
        <style>        
        *{
        -webkit-touch-callout: none;
        -webkit-user-select: none;
        user-select: none;
        -webkit-user-drag: none;
        user-drag: none;
        }
        html,body{
        background-color:#333;
        height: 100%;
        width: 100%;
        margin: 0;
        overflow:hidden;}

        </style>    
    ''');
  if (_customFont == false)
  console_set_custom_font('terminal.png',0,16,16);
}

class Console{
  CanvasElement _container;
  Grid data;
  
  // Default Color Declaration;
  Color defaultBackground = BLACK;
  Color defaultForeground = WHITE;
  
  Console(int x_in_chars,int y_in_chars,int w_in_chars, int h_in_chars){
    data = new Grid(0,0,w_in_chars,h_in_chars,[0,WHITE,BLACK]);
    _container = new CanvasElement()
    ..context2D.imageSmoothingEnabled = false;
    
    
    // Handle Right Clicks
    _container.onContextMenu.listen((MouseEvent m){
      mouse._onRightClick.add(
          {
            'cell': new Point(m.client.x~/_FONT[0].width,m.client.y~/_FONT[0].height),
            'shift':m.shiftKey,
            'alt':m.altKey,
            'console':this
          });
      m.preventDefault();
    });
    
    // Handle Normal Clicks
    _container.onClick.listen((MouseEvent m){
      mouse._onClick.add(
          {
            'cell': new Point(m.client.x~/_FONT[0].width,m.client.y~/_FONT[0].height),
            'shift':m.shiftKey,
            'alt':m.altKey,
            'console':this
          });      
    });
    _container.onDoubleClick.listen((MouseEvent m){
      mouse._onDoubleClick.add(
          {
            'cell': new Point(m.client.x~/_FONT[0].width,m.client.y~/_FONT[0].height),
            'shift':m.shiftKey,
            'alt':m.altKey,
            'console':this
          });            
    });
    
    
    document.body.append(_container);
  }
  
  // Pushes the character data to the Canvas. Refreshes the screen.
  flush(){
    if (_FONT.length >= 1){
    this._container
    ..width = data.width*_FONT[0].width
    ..height = data.height*_FONT[0].height;
    data.forEach((int x,int y,List cell){
      int rune = cell[0];
      Color fgcolor = cell[1];
      Color bgcolor = cell[2];
      
      _FONT[rune].context2D.fillStyle = fgcolor.toString(); 
      _FONT[rune].context2D.globalCompositeOperation = 'source-in';
      _FONT[rune].context2D.fillRect(0, 0, _FONT[rune].width, _FONT[rune].height);
      
      _container.context2D
      ..imageSmoothingEnabled = false
      ..fillStyle = bgcolor.toString()
      ..fillRect((y)*(_FONT[rune].width), (x)*(_FONT[rune].height), _FONT[rune].width,_FONT[rune].height)
      ..fillStyle = fgcolor.toString()
      ..drawImageScaled(_FONT[rune], (y)*(_FONT[rune].width), (x)*(_FONT[rune].height), _FONT[rune].width, _FONT[rune].height);
      });    
    }
  }
  
  // Sets the console back to it's defaults.
  clear(){
    this.data.fill([0,defaultForeground,defaultBackground]);
  }

  close(){
    if (this.hashCode == root.hashCode)
      throw('Cannot close root Console!');
    else
      this._container.remove();
  }
  
  // Changes the background color of a cell
  setCharBackground(int x, int y, Color color,[var flag]){
    if (data.containsCell(x, y)){
      // Do nothing
      if (flag.hashCode == NONE.hashCode){}
      // Set the Color
      else if (flag.hashCode == SET.hashCode || flag == null){
        data[x][y] = [data[x][y][0],data[x][y][1],color];
      }
      // TODO implement other color manipulations
      
    }
  }
  // Changes the foreground color of a cell.
  setCharForeground(int x, int y, Color color,[var flag]){
        data[x][y] = [data[x][y][0],color,data[x][y][2]];
  }
  // Changes the ascii code of the cell.
  setChar(int x, int y, int c){
    data[x][y] = [c,data[x][y][1],data[x][y][2]];
  }
  // Change cell to char, using default coloration.
  putChar(int x, int y, int c){
    data[x][y] = [c,defaultForeground,defaultBackground];
  }
  // Change cell to char, change coloration
  putCharEx(int x, int y, int c, Color foreColor, Color backColor){
    data[x][y] = [c,foreColor,backColor];
  }
  
}

// TODO implement alternative font loading
console_set_custom_font(String location,int flags,[int nbCharHoriz, int nbCharVertic]){
  _customFont = true;
  _FONT = [];
  
  // Load the bitmap font
  ImageElement font = new ImageElement()
  ..src = location;
  font.onLoad.listen((_) {
    
        int char_width = font.width~/nbCharHoriz;
        int char_height = font.height~/nbCharVertic;
        
        int  iw = 0;int  ih = 0;
        for (int i = nbCharHoriz * nbCharVertic;i>=0;i--){
          if (iw >= nbCharHoriz)
            {
              iw = 0;
              ih++;
            }
          
          CanvasElement glyph = new CanvasElement();
          var context = glyph.context2D;
          glyph
          ..width=char_width
          ..height = char_height
          ..context2D.imageSmoothingEnabled = false
          ..context2D.drawImageScaledFromSource(font, char_width*iw, char_height*ih, char_width, char_height, 0, 0, glyph.width, glyph.height);

          ImageData pixels = glyph.context2D.getImageData(0, 0, glyph.width, glyph.height);
          
          List trans = [pixels.data[0],pixels.data[1],pixels.data[2]];
          
          for(var i=0;i<(pixels.data.length);i+=4){
          if (pixels.data[i] == trans[0] && pixels.data[i+1] == trans[1] && pixels.data[i+2] == trans[2])
          pixels.data[i+3]  = 0;
          }          
          
          glyph.context2D.putImageData(pixels, 0, 0, 0, 0, glyph.width, glyph.height);

          _FONT.add(glyph);
          iw++; 
        }
  });
}

//bool console_is_fullscreen(){}
//console_set_fullscreen(bool fullscreen){}
//setWindowTitle(String title){}