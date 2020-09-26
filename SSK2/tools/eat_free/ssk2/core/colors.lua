-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local getTimer  = system.getTimer
local strGSub   = string.gsub
local strSub    = string.sub
local strFormat = string.format
local mFloor    = math.floor
local mRand     = math.random

local colors = {}
_G.ssk = _G.ssk or {}
_G.ssk.colors = colors

-- =============================================================
-- Easy Colors
-- =============================================================
local easy = {}
colors.easy = easy

_G.allColors = {}
_G._TRANSPARENT_ 		= { 0, 0, 0, 0 } 
_G._WHITE_ 			= { 1, 1, 1, 1 }; _G.allColors[#_G.allColors+1] = _G._WHITE_
_G._BLACK_ 			= { 0, 0, 0, 1}; _G.allColors[#_G.allColors+1] = _G._BLACK_
_G._GREY_      		= {0.5, 0.5, 0.5, 1}; _G.allColors[#_G.allColors+1] = _G._GREY_
_G._DARKGREY_  		= { 0.25,  0.25,  0.25, 1}; _G.allColors[#_G.allColors+1] = _G._DARKGREY_
_G._DARKERGREY_  		= { 0.125,  0.125,  0.125, 1}; _G.allColors[#_G.allColors+1] = _G._DARKERGREY_
_G._LIGHTGREY_ 		= { 0.753, 0.753, 0.753, 1}; _G.allColors[#_G.allColors+1] = _G._LIGHTGREY_
_G._RED_   			= { 1, 0, 0, 1 }; _G.allColors[#_G.allColors+1] = _G._RED_
_G._GREEN_ 			= { 0, 1, 0, 1 }; _G.allColors[#_G.allColors+1] = _G._GREEN_
_G._BLUE_  			= { 0, 0, 1, 1 }; _G.allColors[#_G.allColors+1] = _G._BLUE_
_G._CYAN_  			= { 0, 1, 1, 1 }; _G.allColors[#_G.allColors+1] = _G._CYAN_
_G._YELLOW_       	= { 1, 1, 0, 1 }; _G.allColors[#_G.allColors+1] = _G._YELLOW_
_G._ORANGE_       	= { 1, 0.398, 0, 1 }; _G.allColors[#_G.allColors+1] = _G._ORANGE_
_G._BRIGHTORANGE_ 	= { 1, 0.598, 0, 1 }; _G.allColors[#_G.allColors+1] = _G._BRIGHTORANGE_
_G._PURPLE_       	= { 0.625, 0.125, 0.938, 1 }; _G.allColors[#_G.allColors+1] = _G._PURPLE_
_G._PINK_         	= { 1, 0.430, 0.777, 1 }; _G.allColors[#_G.allColors+1] = _G._PINK_

-- Short Names
_G._T_ 	= _G._TRANSPARENT_
_G._W_ 	= _G._WHITE_
_G._K_ 	= _G._BLACK_
_G._R_  	= _G._RED_
_G._G_ 	= _G._GREEN_
_G._B_  	= _G._BLUE_
_G._Y_  	= _G._YELLOW_
_G._O_  	= _G._ORANGE_
_G._P_  	= _G._PINK_
_G._C_  	= _G._CYAN_


-- ==
--    ssk.colors.easy.randomColor() - Returns a randomly chosen color from one of the above colors.
-- ==
local lastColor
function _G.randomColor( )
   local curColor = _G.allColors[mRand(1, #_G.allColors)]
   while(curColor == lastColor) do
      curColor = _G.allColors[mRand(1, #_G.allColors)]
   end
   lastColor = curColor
   return curColor
end

-- ==
--    hexcolor(  ) - converts hex color codes to rgba Graphics 2.0 value
-- ==
function _G.hexcolor( code )
   code = code or "FFFFFFFF"
   code = string.gsub( code , " ", "")
   code = string.gsub( code , "0x", "")
   code = string.gsub( code , "#", "")
   local colors = {1,1,1,1}
   while code:len() < 8 do
      code = code .. "F"
   end
   local r = tonumber( "0X" .. strSub( code, 1, 2 ) )
   local g = tonumber( "0X" .. strSub( code, 3, 4 ) )
   local b = tonumber( "0X" .. strSub( code, 5, 6 ) )
   local a = tonumber( "0X" .. strSub( code, 7, 8 ) )
   local colors = { r/255, g/255, b/255, a/255  }
   return colors
end


-- =============================================================
-- Various Functions
-- =============================================================
-- ==
--    ssk.colors.rgba2(  ) - Converts Graphics 1.0 color table to a valid Graphics 2.0 color table.
-- ==
function colors.rgba2( colors )
   local colors2 = {}
   colors2[1] = colors[1]/255
   colors2[2] = colors[2]/255
   colors2[3] = colors[3]/255
   colors2[4] = (colors[4] or 255)/255
   return colors2
end

-- ==
--    ssk.colors.mixRGB( c1, c2 ) - Evenly mix two RGBa colors.
-- ==
local function mixRGB( c1, c2 )
   local out = {}
   for i = 1, 4 do
      out[i] = ( (c1[i] or 1) + (c2[i] or 1) ) /2
   end
   return out
end
colors.mixRGB = mixRGB

-- ==
--    ssk.colors.randomRGB( [ c1 ] ) - Generates a random RGB color.  If optional c1 is passed in, it is mixed evenly with the random color.
-- ==
function colors.randomRGB( c1 )
  local tmp = { mRand(), mRand(), mRand(), 1 }
  local out = (c1) and mixRGB( c1, tmp ) or tmp
  return out
end

-- ==
--    ssk.colors.pastelRGB( [ c1 ] ) - Generates a random RGB pastel color.  If optional c1 is passed in, it is mixed evenly with the random color.
-- ==
function colors.pastelRGB( c1 )
  local tmp = { mRand(0,50)/100 + 0.5, mRand(0,50)/100 + 0.5, mRand(0,50)/100 + 0.5, 1 }
  local out = (c1) and mixRGB( c1, tmp ) or tmp
  return out
end

-- =============================================================
-- HSL Colors
-- =============================================================
--https://github.com/yuri/lua-colors/blob/master/doc/howto.md
--Color conversions.
--Written by Cosmin Apreutesei. Public Domain.
--Originated from Sputnik by Yuri Takhteyev (MIT/X License).
local function clamp(x) return math.min(math.max(x, 0), 1); end
local function clamp_hsl(h, s, L) return h % 360, clamp(s), clamp(L); end
local function clamp_rgb(r, g, b) return clamp(r), clamp(g), clamp(b); end
local function h2rgb(m1, m2, h)
	if h<0 then h = h+1 end
	if h>1 then h = h-1 end
	if h*6<1 then
		return m1+(m2-m1)*h*6
	elseif h*2<1 then
		return m2
	elseif h*3<2 then
		return m1+(m2-m1)*(2/3-h)*6
	else
		return m1
	end
end

-- ==
--    normRot() - Keep 'angles' in range [0,360)
-- ==
local function normRot( angle )
	while( angle >= 360 ) do angle = angle - 360 end
	while( angle < 0 ) do angle = angle + 360 end
	return angle
end
-- =============================================================
-- Note: hsl is clamped to (0..360, 0..1, 0..1); rgb is (0..1, 0..1, 0..1,0..1)
-- =============================================================
-- =============================================================

-- ==
--    ssk.colors.hsl2rgb( hsla ) - Convert HSL color to RGB color table.
-- ==
function colors.hsl2rgb( hsla )
	local h, s, L = clamp_hsl(hsla[1],hsla[2],hsla[3])
	h = h / 360
	local m1, m2
	if L<=0.5 then
		m2 = L*(s+1)
	else
		m2 = L+s-L*s
	end
	m1 = L*2-m2
	return { h2rgb(m1, m2, h+1/3), h2rgb(m1, m2, h), h2rgb(m1, m2, h-1/3), hsla[4] or 1 }
end

-- ==
--    ssk.colors.rgb2hsl( rgba ) - Convert RGB color to HSL color table.
-- ==
function colors.rgb2hsl( rgba )
	local r, g, b = clamp_rgb(rgba[1] or 1,rgba[2] or 1,rgba[3] or 1)
	local min = math.min(r, g, b)
	local max = math.max(r, g, b)
	local delta = max - min

	local h, s, l = 0, 0, ((min+max)/2)

	if l > 0 and l < 0.5 then s = delta/(max+min) end
	if l >= 0.5 and l < 1 then s = delta/(2-max-min) end

	if delta > 0 then
		if max == r and max ~= g then h = h + (g-b)/delta end
		if max == g and max ~= b then h = h + 2 + (b-r)/delta end
		if max == b and max ~= r then h = h + 4 + (r-g)/delta end
		h = h / 6
	end

	if h < 0 then h = h + 1 end
	if h > 1 then h = h - 1 end

	return { normRot(h * 360), s, l, rgba[4] or 1 }
end

-- ==
--    ssk.colors.hueOffset( hsla, angle ) - Rotate hue by 'angle' degrees
-- ==
function colors.hueOffset( hsla, angle )
	angle = angle or 30
	local tmp = 
	{ 
		normRot( (hsla[1] or 0) + angle),
		hsla[2] or 0,
		hsla[3] or 0,
		hsla[4] or 1
	}
	return tmp
end

-- ==
--    ssk.colors.hslNeighbors( hsla, angle ) - Return two arbitray angle neighbors (left and right by angle)
-- ==
function colors.hslNeighbors( hsla, angle )
	angle = angle or 30
	return colors.hueOffset( hsla, angle ), colors.hueOffset( hsla, -angle ) 
end

-- ==
--    ssk.colors.hslTriadic( hsla ) - Return two triadic neighbors of color
-- ==
function colors.hslTriadic( hsla )
	return colors.hslNeighbors( hsla, 120 )
end

-- ==
--    ssk.colors.hslSplitComplementary( hsla, angle ) - Return two complementary split angle colors. 
-- ==
function colors.hslSplitComplementary( hsla, angle )
	angle = angle or 30
	local n1, n2 = colors.hslNeighbors( hsla, 180 - angle )
	return n1, n2
end

-- ==
--    ssk.colors.rgbOffset( rgba, angle ) - Converts RGB color to HSL and applies hueOffset()
-- ==
function colors.rgbOffset( rgba, angle )
	local tmp = colors.rgb2hsl( rgba )
	tmp = colors.hueOffset( tmp, angle )
	tmp = colors.hsl2rgb( tmp )
	return tmp
end

-- ==
--    ssk.colors.rgbNeighbors( rgba, angle ) - Converts RGB color to HSL and applies hslNeighbors()
-- ==
function colors.rgbNeighbors( rgba, angle )
	local tmp = colors.rgb2hsl( rgba )
	local tmp1, tmp2 = colors.hslNeighbors( tmp, angle )
	tmp1 = colors.hsl2rgb( tmp1)
	tmp2 = colors.hsl2rgb( tmp2)
	return tmp1, tmp2
end

-- ==
--    ssk.colors.rgbTriadic( rgba ) - Converts RGB color to HSL and applies hslTriadic()
-- ==
function colors.rgbTriadic( rgba )
	local tmp = colors.rgb2hsl( rgba )
	local tmp1, tmp2 = colors.hslTriadic( tmp )
	tmp1 = colors.hsl2rgb( tmp1)
	tmp2 = colors.hsl2rgb( tmp2)
	return tmp1, tmp2
end


-- ==
--    ssk.colors.rgbSplitComplementary( rgba, angle ) - Converts RGB color to HSL and applies hslSplitComplementary()
-- ==
function colors.rgbSplitComplementary( rgba, angle )
	local tmp = colors.rgb2hsl( rgba )
	local tmp1, tmp2 = colors.hslSplitComplementary( tmp, angle )
	tmp1 = colors.hsl2rgb( tmp1 )
	tmp2 = colors.hsl2rgb( tmp2 )
	return tmp1, tmp2
end


return colors
