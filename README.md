libpen
=========
libpen is a Console Emulation library written in dart.

* designed specifically for developing ASCII roguelikes.
* inspired spiritually and syntactically by [libtcod](http://doryen.eptalys.net/libtcod/), [malison](https://github.com/munificent/malison), and [rot.js](http://ondras.github.io/rot.js/hp/).

Simple setup:
    
    //import the library. 
    import 'package:libpen/libpen.dart' as libpen; 

    //create the Console.
    libpen.Console console = new libpen.Console(60,42);
    
    //Add it to the page 
    document.body.append(console.container);

Easy use:

    //change a cell.
    console.setGlyph(5,5,'@');
    console.setForeground(5,5, Color.RED);
    console.setBackground(5,5, Color.GREEN);
    
    //or alternatively:
    console.put(5,5,'@',Color.RED,Color.GREEN);
    
    //flush the changes to the console.
    console.flush();
    
    // => and at 5,5 there is now a red '@' on a green background.

Small features: 

* Canvas coordinate mouse support
* String drawing with simple word wrap
* User defined Bitmap Fonts
* Included IBM Code Page 437
