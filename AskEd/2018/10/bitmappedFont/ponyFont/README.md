**ponyfont**  -- Modern Bitmap Font Support for Corona SDK
====
Bitmap fonts consist of two files, a PNG texture and a FNT file that describes the glyphs size and placement. This module reads an [Angel Code](http://www.angelcode.com/products/bmfont/) or [ShoeBox](http://renderhjs.net/shoebox/bitmapFont.htm) compatible FNT bitmap font and corresponding PNG texture and returns a displayGroup with each letter in order as the children of that display group. It also monitors properties like text, align, fontSize for changes and re-renders accordingly.

There are many partial attempts of a BMF importer, but most rely on deprecated functionality and require additional code to integrate. The goal of **ponyfont** is to have a replacement for display.newText() with similar arguments and rendering.

![alt text](https://raw.githubusercontent.com/ponywolf/ponyfont/master/ponyfont-gif-preview.gif "Ponyfont in action")

*In this example, a bitmap font is shown side by side with it's TrueType counterpart. Size, placement and word wrap are all consistent.*

Syntax
----------
>ponyfont = require "com.ponywolf.ponyfont"

>local text = ponyfont.newText( options )

This function takes a single argument, options, which is a table that accepts the following parameters:

**text** (required)
String. The text to display.

**x, y** (optional)
Numbers. Coordinates for the object's x and y center point.

**width** (optional)
Number. Optional parameters to enable multi-line text. Text will be wrapped at width and be cropped at height. The width parameter is required if you use the align property (see below).

**font** (required)
String. Name of the font file that contains the Angel Code FNT file. The module will look for the PNG textures specified in that FNT file in the same directory as the FNT file.

**fontSize** (optional)
Number. The size of the text in Corona content points. The module will scale the glyphs to match the font size as similarly as possible. This may lead to blurry text if the texture is not significantly large enough to support the type size.

**align** (optional)
String. This specifies the alignment of the text when a width parameter is supplied. Default value is "left". Valid values are "left", "center", or "right". See the code examples below.

Examples
---------

Many of the [CoronaSDK text examples](https://docs.coronalabs.com/api/library/display/newText.html) run as-is, by simply replacing the font parameter with the sample FNT/PNG included in this repository.