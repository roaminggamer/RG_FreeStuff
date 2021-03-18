display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages


	local good_vertices = {
	    0, -10.164,
	    30.8, -10.164,
	    30.8, -20.328,
	    61.6, -20.328,
	    61.6, -30.492,
	    92.4, -30.492,
	    92.4, -40.656,
	    123.2, -40.656,
	    123.2, -50.82,
	    154, -50.82,
	    154, -60.984,
	    184.8, -60.984,
	    184.8, -71.148,
	    215.6, -71.148,
	    215.6, -81.312,
	    246.4, -81.312,
	    246.4, -91.476,
	    277.2, -91.476,
	    277.2, -101.64,
	    308, -101.64,
	    308, -111.804,
	    338.8, -111.804,
	    338.8, -121.968,
	    369.6, -121.968,
	    369.6, -132.132,
	    400.4, -132.132,
	    400.4, -142.296,
	    431.2, -142.296,
	    431.2, -152.46,
	    462, -152.46,
	    462, -162.624,
	    492.8, -162.624,
	    --492.8, -172.788,
	    --523.6, -172.788,
	    523.6, 1080,
	    0, 1080,
	}

	local bad_vertices = {
	    0, -10.164,
	    30.8, -10.164,
	    30.8, -20.328,
	    61.6, -20.328,
	    61.6, -30.492,
	    92.4, -30.492,
	    92.4, -40.656,
	    123.2, -40.656,
	    123.2, -50.82,
	    154, -50.82,
	    154, -60.984,
	    184.8, -60.984,
	    184.8, -71.148,
	    215.6, -71.148,
	    215.6, -81.312,
	    246.4, -81.312,
	    246.4, -91.476,
	    277.2, -91.476,
	    277.2, -101.64,
	    308, -101.64,
	    308, -111.804,
	    338.8, -111.804,
	    338.8, -121.968,
	    369.6, -121.968,
	    369.6, -132.132,
	    400.4, -132.132,
	    400.4, -142.296,
	    431.2, -142.296,
	    431.2, -152.46,
	    462, -152.46,
	    462, -162.624,
	    492.8, -162.624,
	    492.8, -172.788,
	    523.6, -172.788,
	    523.6, 1080,
	    0, 1080,
	}

local function v1()
	local newPoly = display.newPolygon( display.contentCenterX, display.contentCenterY, good_vertices )
	newPoly.anchorY = 0
	newPoly:setFillColor(0,1,0)
end

local function v2()
	local newPoly = display.newPolygon( display.contentCenterX, display.contentCenterY, bad_vertices )
	--newPoly:setFillColor(1,0,0)
	newPoly.anchorY = 0
end


local function v3()
	for i =1, #bad_vertices do
		bad_vertices[i] = math.round(bad_vertices[i])
	end
	local newPoly = display.newPolygon( display.contentCenterX, display.contentCenterY, bad_vertices )
	newPoly.anchorY = 0
	newPoly:setFillColor(0,0,1)
end

--v1()
--v2()
v3()