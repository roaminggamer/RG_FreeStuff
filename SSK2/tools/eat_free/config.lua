-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local mode = "development"
local mode = "production"

if(mode == "development") then
	-- Development
	application = {
		content = {
			width   = 1200, --* 2, 
			height  = 675, -- * 2, 
			scale   = "letterbox",		
			fps 	= 60,
			--antialiasing = true
		},
	}
else
	-- Production
	application = {
		content = {
			width    	= 1080, 
			height   	= 1920, 
			scale    	= "adaptive",		
			fps 		= 60,
	      	xAlign      = "left",
	      	yAlign      = "top",

		},
	}
end


