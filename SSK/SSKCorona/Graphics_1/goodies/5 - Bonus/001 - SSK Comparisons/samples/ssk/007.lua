-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Solid Segmented Line
local points = ssk.points:new() 
for i = 40, w-40, 5 do
	points:add( i, centerY - 100 + math.random( -20, 20 ) )
end
ssk.display.segmentedLine( group, points, { width = 3, color = _RED_ } )


-- Dashed Segmented Line
points = ssk.points:new() 
for i = 40, w-40, 5 do
	points:add( i, centerY - 30 )
end
ssk.display.segmentedLine( group, points, { width = 3, color = _GREEN_, style = "dashed" } )


-- Dotted Segmented Line
points = ssk.points:new() 
for i = 40, w-40, 20 do
	points:add( i, centerY + 30 + math.random( -20, 20 ) )
end
ssk.display.segmentedLine( group, points, { color = _TRANSPARENT_, style = "dotted", radius = 5, 
                                          stroke = _YELLOW_, strokeWidth = 2 } )


-- Solid + Arrowheads Segmented Line
points = ssk.points:new() 
for i = 40, w-40, 40 do
	points:add( i, centerY + 100 + math.random( -20, 20 ) )
end
ssk.display.segmentedLine( group, points,  { color = _BRIGHTORANGE_ } )
ssk.display.segmentedLine( group, points, { color = _BLUE_, style = "arrowheads"} )


return group
