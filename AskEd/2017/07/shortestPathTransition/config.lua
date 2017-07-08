application =
{

	content =
	{
		width = 640, -- EFM
		height = 960, -- EFM
		scale = "letterBox",
		fps = 30,

		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]
}
