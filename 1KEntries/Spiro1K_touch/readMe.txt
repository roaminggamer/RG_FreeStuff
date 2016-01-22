
Spiro1K Touch (Roaming Gamer; Entry #3; 856 bytes)
--------------------------------------------------

This is my third entry for the "Code Less. Play More. 1K Contest".

This is an app that automatically draws a single 'spriograph' every time you touch 
the screen.  Each new spirograph takes 22.5 seconds to draw, then stops.

It is a follow-on to 'Spiro1K Inifinite'.  I made this for those who want more
control.

If you don't like your spirograph, just way for the last touch to stop drawing
and swipe left-to-right.  This will clear the screen.  Then you can tap, tap,
tap... to start again.



Implemenation Details
---------------------
* This entry is 896 bytes long as measured by Windows 7 Explorer
* The game uses physics joints and three proxy objects (circles) to achieve the 
  behind the scenes magic.
* It uses math.random() to select the sizes of the circles, the locations of
  the joints, and the colors of the spirograph lines.
* The spirograph finshes drawing after about 22.5 seconds, so you should never
  get a old pattern still drawing on a new one.  But hey, you can't
  do much checking in 1K of code.
* The 'allowed' files can be found in the "code/" subfolder.



Ed Maurina of 
Roaming Gamer, LLC. 
http://roaminggamer.com/


