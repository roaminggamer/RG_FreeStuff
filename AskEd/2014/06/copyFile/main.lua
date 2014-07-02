
local GGFile = require( "GGFile" )
local fileManager = GGFile:new()


fileManager:copyBinary( "smiley.png", system.ResourceDirectory, "smiley.png", system.DocumentsDirectory )

fileManager:copy( "test.txt", system.ResourceDirectory, "test.txt", system.DocumentsDirectory )


local tmp = display.newText( "Image in documents folder? ==> " .. tostring(fileManager:exists( "smiley.png", system.DocumentsDirectory)), 20, 100, native.systemFont, 30 )
tmp.anchorX = 0

local tmp = display.newText( "Text file in documents folder? ==> " .. tostring(fileManager:exists( "test.txt", system.DocumentsDirectory)), 20, 200, native.systemFont, 30 )
tmp.anchorX = 0