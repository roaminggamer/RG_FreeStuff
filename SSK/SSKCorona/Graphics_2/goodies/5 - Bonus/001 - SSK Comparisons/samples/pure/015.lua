-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY
local w				= display.contentWidth


-- Creating a layering system involves the use of display groups.  
-- 
-- In the following code I create four groups. Three act as layers while
-- the fourth group acts as a container and owner for all the other layers.
-- This makes future cleanup as easy as the removal of the 'owner' layer.
--
-- Note: I also store the child groups as handles on the 'owner' group.
--
local layers = display.newGroup()
group:insert(layers)

-- Created in 'any old' order for demonstration purposes
layers.middle = display.newGroup()
layers.bottom = display.newGroup()
layers.top = display.newGroup()

-- Enforce layering order by inserting the layers we want (bottom-to-top) in the owner group.
layers:insert( layers.bottom )
layers:insert( layers.middle )
layers:insert( layers.top )


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
