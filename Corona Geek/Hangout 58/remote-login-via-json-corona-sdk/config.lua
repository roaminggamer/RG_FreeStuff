-- config.lua

local targetDevice = ( system.getInfo( "model" ) ) 
local isTall = ( "iPhone" == system.getInfo( "model" ) ) and ( display.pixelHeight > 960 )

if isTall == false and targetDevice == "iPhone" then
application = 
{
	content = 
	{
		width = 320,
		height = 480,
		scale = "letterbox",
		fps = 60,
                antialias = true,
                xalign = "center",
                yalign = "center",
		imageSuffix = 
        {
            ["@2x"] = 2,
        },
    },
}

elseif isTall == true then
application = 
{
	content = 
	{
		width = 320,
		height = 568,
		fps = 60,
                antialias = true,
                xalign = "center",
                yalign = "center",
    },
}

elseif targetDevice == "iPad" then
application = 
{
	content = 
	{
		width = 768,
		height = 1024,
		scale = "letterbox",
		fps = 60,
                antialias = true,
                xalign = "center",
                yalign = "center",
		imageSuffix = 
        {
            ["@2x"] = 2,
        },
    },
}
end



if system.getInfo("platformName") == "Android" then
	application =
	{
		content =
		{
			--zoom
			width = 320,
			height = 480,
			scale = "letterbox"
		},
	}
end