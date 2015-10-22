part of test;


// Test the ability to draw images onto a canvas.
// makes sure that no errors are thrown if out of bounds
testDraw() {
  Console console = new Console(60,52);
  html.document.body.append(console.container);

  Image i = new Image(60,52);
  for (Char char in i.charData)
    char
      ..backColor = Color.RED;

  Field background = new Field(58, 50)
    ..x = 1
    ..y = 1
    ..image = i;


  Image j = new Image(52,60);
  for (Char char in j.charData)
    char
      ..backColor = Color.BLUE;

  Field window = new Field(10,10)
    ..image = j
    ..x = 1
    ..y = 1;

  background.children.add(window);

  console.drawImage(background.x,background.y, background.render());
  console.flush();
}