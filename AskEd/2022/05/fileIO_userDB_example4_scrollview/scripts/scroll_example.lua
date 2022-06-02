-- =============================================================
local user_db_module = require "scripts.user_db_module"
local widget = require("widget") -- for status label

-- =============================================================
-- =============================================================
-- Snagged basic example from here and modified slightly
-- https://docs.coronalabs.com/api/library/widget/newScrollView.html#examples
--
-- More docs:
-- https://docs.coronalabs.com/api/type/ScrollViewWidget/index.html


-- Create the widget
local scrollView = widget.newScrollView(
    {
        top = 100,
        left = 10,
        width = 300,
        height = 400,
        scrollWidth = 600,
        scrollHeight = 800,
        -- listener = scrollListener
    }
)

local background = display.newImageRect( "image/dummy.png", 768, 1024 )
background:setFillColor(0.2, 0.5, 0.2)
scrollView:insert( background )


-- Add names to widte

local numRecords = user_db_module.getRecordCount()
local curY = 0

if( numRecords > 0 ) then
   for i = 1, numRecords do
      local rec = user_db_module.getRecordByIndex(i)

      -- https://docs.coronalabs.com/api/library/display/newText.html
      -- display.newText( [parent,] text, x, y [, width, height], font [, fontSize] )
      local nameText = display.newText(  rec.name, 10, curY, native.systemFont, 16 )

      -- https://docs.coronalabs.com/guide/graphics/transform-anchor.html
      nameText.anchorX = 0
      nameText.anchorY = 0

      scrollView:insert( nameText )
      
      curY = curY + nameText.contentHeight + 5
   end



   
end
