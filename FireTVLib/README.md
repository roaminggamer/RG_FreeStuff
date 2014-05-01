Fire TV Lib ++
==========================

Notes: 

- You are mostly on your own using this library (as it is free).  However, I think the examples in the 'verify' folder should be fairly straight forward.
- This is for the standard Fire TV control.  I am working on a Fire TV 'Game Controller' library, but it may take some time as I'm kind of busy. :)

A. Test - This app was used to test for inputs from standard Fire TV input device.

B. Lib - A small library/module to map keys from the FireTV input.

C. Verify - This app was used to verify the resultant 'library' made from the 'test' results.

D. composerFrame - This is an empty composer framework using SSK and the Fire TV Lib.  It contains these interfaces:

- Splash
- Main Menu (Fully Mapped to Fire FTV)
- Play GUI place holder (Fully Mapped to Fire FTV)
- Credits GUI place holder (Fully Mapped to Fire FTV)
- Options GUI place holder (Partially Mapped to Fire FTV)

Be aware, although this sample is thin, light, and straightforward, you will still have to dig to learn and use it.  Oddly, the primary impediment here may be the use of SSK.  I used it because it reduced the effort to make buttons, fly-ins, etc. However, you may wish to replace the SSK parts with Pure Corona SDK code or your own libs.  


Key Mappings
==========================
The input keys are mapped as follows:

Fire TV
Input Key    / "keyName" encoding
Up           / "up"
Down         / "down"
Left         / "left"
Select       / "select"
Back         / "back"
Menu         / "menu"
Rewind       / "rewind"
Fast forward / "fastForward"
Play-Pause   / "playPause"

To allow for testing on a simulator, the keys are also mapped on Windows and OS X keyboards as follows:

OS X and Windows Keyboards
Input Key    / "keyName" encoding
Up           / "up"
Down         / "down"
Left         / "left"
s            / "select"
b            / "back"
m            / "menu"
r            / "rewind"
f            / "fastForward"
p            / "playPause"


No other key inputs/touches/presses will produce the 'onFTVKey' event.


