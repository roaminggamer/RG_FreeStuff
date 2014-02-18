--calculate the aspect ratio of the device
local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
   content = {
      width = aspectRatio > 1.5 and 800 or math.ceil( 1200 / aspectRatio ),
      height = aspectRatio < 1.5 and 1200 or math.ceil( 800 * aspectRatio ),
      scale = "letterBox",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.3,
      },
   },
}



--[[
application = {
	content = {
		width = 320,
		height = 480, 
		scale = "letterBox", -- Good in some cases
	},
}
--]]