part of test;


// Test the ability to draw images onto a canvas.
// makes sure that no errors are thrown if out of bounds
testDraw() {
  Root root = new Root(60,52);
  Console console = root.console;
  html.document.body.append(console.container);

  Image i = new Image(60,52);
  for (Char char in i.charData)
    char
      ..backColor = Color.RED
      ..glyph = '#'.codeUnitAt(0);

  Field background = new Field(58, 50)
    ..x = 1
    ..y = 1
    ..image = i;

  ScrollField window = new ScrollField(20,10)
    ..x = 10
    ..y = 10;

  background.append(window);

  Image text = new Image(19, 20)
    ..drawText(0,0,'Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master Hello There fellas, I am the turtle dove master ', 19);

  Field textField = new Field(19,20)
    ..image = text;

  window.append(textField);

  root.append(background);
  console.flush();
}