io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local appPreferences =
{
    myBoolean = true,
    myNumber = 123.45,
    myString = "Hello World"
}
system.setPreferences( "app", appPreferences )
 
-- Read the preferences that were written to storage above
local myBoolean = system.getPreference( "app", "myBoolean", "boolean" )
local myNumber = system.getPreference( "app", "myNumber", "number" )
local myString = system.getPreference( "app", "myString", "string" )

print( myBoolean, myNumber, myString )