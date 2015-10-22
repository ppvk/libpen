part of test;


// Test the ability to draw images onto a canvas.
// makes sure that no errors are thrown if out of bounds
testDraw() {
  Console console = new Console(100,100);
  html.document.body.append(console.container);
  
  Image i = new Image(10,10);
  for (Char char in i.charData)
    char
      ..glyph = 2
      ..backColor = Color.RED;
  
  console.drawImage(2, 2, i);
  console.setChar(5, 5, '5');
  console.flush();
}