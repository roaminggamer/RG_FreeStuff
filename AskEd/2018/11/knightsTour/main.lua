io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "orig"
local cleaned = require "cleaned"

for kx = 1, 8 do
	for ky = 1, 8 do
		cleaned.run( { kx = kx, ky = ky, quiet = true } )
	end
end