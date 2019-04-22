io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================

local imagePath = "images/smiley.png"


local test = display.newImageRect( imagePath , 40, 40 )
test.x = centerX
test.y = centerY - 200

-- use standard corona features
local path1 = system.pathForFile( imagePath )
local label1 = display.newText( path1, centerX, centerY - 100, nil, 14 )


-- Now use ssk files.* - https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/files/
local path2 = ssk.files.resource.getPath( imagePath )
path2 = ssk.files.util.repairPath( path2, true )

local label2 = display.newText( path2, centerX, centerY, nil, 14 )