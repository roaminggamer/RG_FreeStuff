-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup() 

-- Notice that creating layers is a simple as single function call when using SSK.
--
-- The pure version of this code required seven lines of code for the equivalent result.
--
-- Note: quickLayers() also provides the ability to create grandchild layers for parallax and other uses, again
-- all in one line of code.
--
local layers = ssk.display.quickLayers( group, "bottom", "middle", "top" )

-- Create a Red, Green, and Blue Circle layered as follows:
--   Red - Top
-- Green - Middle
--  Blue - Bottom

-- Normally, layering is creation order dependent, where the first object created is on the bottom, and the
-- object created is on the top.
--
-- However, by using a layering system, we can create these in any order and still get the result we want.
--

-- Green
local green = display.newCircle( layers.middle, centerX, centerY, 40 )
green:setFillColor( 0,255,0)

local red   = display.newCircle( layers.top, centerX-10, centerY, 40 )
red:setFillColor( 255,0,0)

local blue  = display.newCircle( layers. bottom, centerX+10, centerY, 40 )
blue:setFillColor( 0,0,255)

return group
