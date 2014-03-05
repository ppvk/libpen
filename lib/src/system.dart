part of libpen;
// System

setFps(int val){}

int getFps(){}

int get_last_frame_length(){}

int getElapsedMilli(){}

int getElapsedSeconds(){}

List <int> getFullscreenOffsets(){}

// Doesn't return right if our font isn't loaded completely.
List <int> getCharSize(){return [_FONT[0].width,_FONT[0].height];}

setClipboard(String value){}

String getClipboard(){}