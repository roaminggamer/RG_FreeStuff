MLText
============

This is a simple Markup Language Text Object and Image Creator.

It supports these markup tags:

 
 <font></font> - Font Tag
 
 Including the options:
 ** face - Font name.
 ** size - Font size.
 ** color - One of the 216 standard color names (See GGColour.lua for supported color names.)

 Example : 
 <font face = "Tahoma" size="22" color="ForestGreen">This is a test font tags.</font>

 
 <br> - Line break tag

 
 <a></a> - Address tag
 
  Example: <a href = "www.roaminggamer.com">Roaming Gamer, LLC.</a>


  <img> - Image tag
  
  Including these options
  src - Path and filename of image.
  width - Width of image. (Defaults to height.)
  height - Height of image. (Defaults to width.)
  xOffset - X pixels to offset image. (Not standard HTML)
  yOffset - Y pixels to offset image. (Not standard HTML)

  Note: If width and height are not specified, the image is made with newImage(), otherwise, newImageRect() is used.

  Please see the example that comes with this code.

  You are free to modify this library/module as you need.  Have fun!

