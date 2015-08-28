-- 
-- Abstract: Hello World sample app, using native iOS font 
-- To build for Android, choose an available font, or use native.systemFont
--
-- Version: 1.2
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

local myText = display.newText( " Hello, World! ", display.contentCenterX, display.contentWidth / 4, "GothicBold", 10 )
myText.x, myText.y = display.contentWidth/2, display.contentHeight/2
myText:setFillColor(0,1,0)

local myText2 = display.newText( " Hello, World! ", display.contentCenterX, display.contentWidth / 4, native.systemFont, 40 )
myText2.x, myText2.y = myText.x, myText.y + 50
myText2:setFillColor(1,0,0)

-- Code grabbed from here, then modified: https://docs.coronalabs.com/api/library/native/getFontNames.html
local searchString = "gothic"
local systemFonts = native.getFontNames()
for k,v in pairs( systemFonts ) do
    local found = string.find( string.lower(v), string.lower(searchString) )
    if( found ) then
        print( "Font Name = " .. tostring( v ) )
    end
end


