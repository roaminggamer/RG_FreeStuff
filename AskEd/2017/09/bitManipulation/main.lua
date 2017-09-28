-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { useExternal = true } )
-- =============================================================
local bits = require "bits"

local a = 0xFFFFFFFF
local b = 0xFFFFFFFF
print( string.format( "0X%8.8X OR 0X%8.8X == 0X%8.8X", a, b, bits.OR(a,b) ) )
print( string.format( "0X%8.8X AND 0X%8.8X == 0X%8.8X", a, b, bits.AND(a,b) ) )
print( string.format( "0X%8.8X XOR 0X%8.8X == 0X%8.8X", a, b, bits.XOR(a,b) ) )

for i = 1, 32 do
	local a = 0x1
	print( string.format( "0X%8.8X << %d == 0X%8.8X", a, i-1, bits.SHIFTLEFT(a,i-1) ) )
end

for i = 1, 32 do
	local a = 0X80000000
	print( string.format( "0X%8.8X >> %d == 0X%8.8X", a, i-1, bits.SHIFTRIGHT(a,i-1) ) )
end
