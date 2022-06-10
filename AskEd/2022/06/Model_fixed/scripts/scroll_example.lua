-- =============================================================
local user_db_module = require "scripts.user_db_module"


local background = display.newImageRect( "image/dummy.png", 768, 1024 )
background:setFillColor(0.2, 0.5, 0.2)
--scrollView:insert( background )


-------------------------------------------------
local curY = 0
local numRecords = user_db_module.getRecordCount()
if( numRecords > 0 ) then
   for i = 1, numRecords do

local rec = user_db_module.getRecordByIndex( i )
-------------------------------------------------------
     local nameText = display.newText(  rec.name, 10, curY, native.systemFont, 16 )
           -- nameText:setFillColor(0, 0, 0)
      nameText.anchorX = 0
      nameText.anchorY = 0
    curY = curY + nameText.contentHeight + 5   ----------separateur des noms
  
end
end
