part of test;


// Tests that colors and color manipulations work properly.
testColors() {
  //TODO write some more color tests
  assert(Color.PURPLE - Color.RED == Color.BLUE);
  assert(Color.WHITE.toString() == 'rgba(255,255,255,255)');
}