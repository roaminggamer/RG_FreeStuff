-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (17/45)
-- =============================================================
-- Toy: Color Grid (looks best on 640x960)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- TOY CODE BEGINS BELOW
-- =============================================================

-- From: https://rosettacode.org/wiki/Least_common_multiple#Lua
local function gcd( m, n )
    while n ~= 0 do
        local q = m
        m = n
        n = q % n
    end
    return m
end
 
local function lcm( m, n )
    return ( m ~= 0 and n ~= 0 ) and m * n / gcd( m, n ) or 0
end

-- =============================================================
-- Localizations
-- =============================================================
local mRand = math.random
local newRect = ssk.display.newRect
local RGColor = ssk.colors
local size1 = gcd(w, h)/8 --gcd(fullw, fullh)/8
local size2 = size1 - 5
local cols = w/size1 --fullw/size1
local rows = h/size2 --fullh/size2

for i = 1, cols do
	for j = 1, rows, 3 do
		local c1 = RGColor.randomRGB()
		local c1_hsl = RGColor.rgb2hsl(c1)
		local c2_hsl, c3_hsl = RGColor.hslSplitComplementary( c1_hsl, 90 )
		local c2 = RGColor.hsl2rgb( c2_hsl )
		local c3 = RGColor.hsl2rgb( c3_hsl )
		local tmp = newRect( nil, left + size1/2 + (i-1) * size1, top + size1/2 + (j-1) * size1, 
			                 { size = size2, fill = c1 } )
		local tmp = newRect( nil, left + size1/2 + (i-1) * size1, top + size1/2 + (j-1+1) * size1, 
			                  { size = size2, fill = c2 } )
		local tmp = newRect( nil, left + size1/2 + (i-1) * size1, top + size1/2 + (j-1+2) * size1, 
			                  { size = size2, fill = c3 } )
	end
end

