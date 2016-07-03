io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
----------------------------------------------
-- IGNORE ABOVE THIS LINE
----------------------------------------------
display.setDefault('minTextureFilter', 'nearest')
display.setDefault('magTextureFilter', 'nearest')
display.setDefault('isImageSheetSampledInsideFrame', true)

--require "test1" -- discrete images
require "test2" -- spritesheet sourced images
