
SSK RGGlobals
============
SSKCorona RGGlobals adds a number of useful variables and functions to the global space.

Warning! - Yes, I know this is not the best practice, but I have found having these variables and functions to be fairly indispensible.

For your protection. I have implemented a 'safe global' watch feature.  It will throw an error if the library tries to create a global that already exists.


Basic Usage
-------------------------
Download this library and copy the ssk folder into your project's root directory.  Then require the code.
```lua
require "ssk.RGGlobals"
```

Global Variables
-------------------------
* `SPC` `NL` `TAB` - Character encodings for space, newline, and tab.
* `w` `h` `centerX` `centerY` - Design width, height, and center <x,y> (as specified by config.lua).
* `displayWidth` `displayHeight` - Scaled width and height of display.  May be larger than  w or h.  Can occur with 'storyboard' scaling.
* `unusedWidth` `unusedHeight` - Extra pixels in with or height bounds (specified in design resolution.)  Can occur with 'storyboard' scaling.
* `deviceWidth` `deviceHeight` - True pixel width and height of device display.
* `luaVersion` - Version code for LUA in this version of Corona.
* `onSimulator` - Running on simulator?
* `oniOS` `onAndroid` `onOSX` `onWin` - Flags for various OSes.
* `platformVersion, olderVersion - Version of current platform and (for iOS) running on iOS version < 4?`

* Easy Color (Tables):  `_TRANSPARENT_` `_WHITE_` `_BLACK_` `_GREY_` `_DARKGREY_` `_DARKERGREY_` `_LIGHTGREY_` `_RED_` `_GREEN_` `_BLUE_` `_YELLOW_` `_ORANGE_` `_BRIGHTORANGE_` `_PURPLE_` `_PINK_`


Global Functions
-------------------------
* `listen( name, listener )` - Shorthand notation for 'Runtime:addEventListener( obj, listener)'.
* `ignore( name, listener )` - Shorthand notation for 'Runtime:removEventListener( obj, listener)'.
* `post( name [ , params [, debuglvl ]] )` - Shorthand notation for 'Runtime:dispatch( event )' with optional debug output.  Warning: debuglvl 2+ requires 'RGExtensions'.
* `noErrorAlerts(  )` - Turns off those annoying error popups! :)
* `fnn( ... )` - Return first argument from list that is not nil.
* `isDisplayObject( obj )` - Check if an object is valid and has NOT had removeSelf() called yet.
* `safeRemove( obj )` - Safely remove a display object.  (Legacy) Simply uses 'display.remove( obj )' internally now.
* `randomColor()` - Returns a table containing a random color code from the set allColors defined in ssk/globals.lua.
* `round(val, n)` - Rounds a number to the nearest decimal places.
* `isConnectedToWWW( [ url ] )` - Checks to see if device is able to reach web as (optionally) specified url.





Short and Sweet License 
--------------------------
1. You MAY use anything you find in SSKCorona to:
  * make applications for free or for profit ($).
  * make games for free or for profit ($).  
  
2. You MAY NOT:
  * sell or distribute SSKCorona or the sampler as your own work
  * sell or distribute SSKCorona as part of a book, starter kit, etc.

3. It would be nice if everyone who uses SSK were to give me credit, but I understand that may not always be possible.  So, if you can please give a shout out like: "Made with SSKCorona, by Roaming Gamer, LLC.", super, if not, darn...  Also, if you want to link back to my site that would be awesome too:   http://www.roaminggamer.com/




