libpen
=========
libpen is a Console Emulation library written in dart.

* designed specifically for developing ASCII roguelikes.
* inspired spiritually and syntactically by libtcod and rot.js.
* depends solely on dart:core and dart:html.


Simple setup:
    
    //import the library. 
    import 'package:libpen/libpen.dart' as libpen; 

    //create the Console.
    libpen.Console console = new libpen.Console(60,42);
    
    //Add it to the page 
    document.body.append(console.container);

Easy use:

    //change a cell.
    console.setChar(5,5,'@');
    console.setCharForeground(5,5,RED);
    console.setCharBackground(5,5,GREEN);
    
    //or alternatively:
    console.putChar(5,5,'@',RED,GREEN);
    
    //flush the changes to the console.
    console.flush();
    
    // => and at 5,5 there is now a red '@' on a green background.

Small features: 

* Mouse Support
* String drawing with word wrap