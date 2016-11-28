local sysModel = system.getInfo("model")

if sysModel ~= "iPad" then
	application = 
	{
		content = 
		{ 
			width = 320*2,
			height = 480*2,
			scale = "letterbox",
			fps = 60,
			
			imageSuffix = {
				["@2x"] = 2,
			}
		}
	}

else

	application = 
	{
		content = 
		{ 
			width = 768*2,
			height = 1024*2,
			scale = "letterbox",
			fps = 60,
			
			imageSuffix = {
				["@2x"] = 2,
			}
		}
	}
end