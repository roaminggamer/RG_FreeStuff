local layers

local function get( group )
	if( layers == nil ) then
		layers = ssk.display.quickLayers( group, 
			"underlay", 
			"background", 
			-- Content:
			"story",
			"inv",
			"status",
			"map",
			"options",
			"locationBar",
			"botBar", 
			"popup", 
			"overlay" )
	end
	return layers
end

local function destroy()
	display.remove(layers)
	layers = nil
end

local public = {}
public.get 		= get
public.destroy 	= destroy
return public