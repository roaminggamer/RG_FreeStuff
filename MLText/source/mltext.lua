
-- ==
--    shallowCopy( src [ , dst ]) - Copies single-level tables; handles non-integer indexes; does not copy metatable
-- ==
function shallowCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		dst[k] = v
	end
	return dst
end

-- Lua HTML Parser
-- https://github.com/luaforge/html/tree/master/html
local html = require "html"

-- GlitchGames/GGColour
-- https://github.com/GlitchGames/GGColour
local ggcolor = require "GGColour"
local colorChart = ggcolor:new()


local function newMLText( words, x, y, params )
	local group = display.newGroup()
	local words = string.gsub(words, "[\r\n]", "")
	words = string.gsub(words, "\t", "   ")
	twords = html.parsestr(words)
	local startX = x or 0
	local lastX = startX
	local y = y or 0

	--table.print_r( twords )

	local params = params or 
	{
		font = native.defaultFont,
		fontSize = 12,
		fontColor = {0,0,0},
		spaceWidth = 1,
		lineHeight = 12,
		linkColor1 = {0,0,255},
		linkColor2 = {255,0,255},
	}

	params.font			= params.font or native.defaultFont
	params.fontSize		= params.fontSize or 12
	params.fontColor	= params.fontColor or {0,0,0}
	params.spaceWidth	= params.spaceWidth or 1
	params.lineHeight	= params.lineHeight or 12
	params.linkColor1	= params.linkColor1 or {0,0,255}
	params.linkColor2	= params.linkColor2 or {255,0,255}
	

	local function onTouch( self, event )
		if(event.phase == "began") then
			for i = 1, self.numChildren do
				if(self[i].isText) then
					self[i]:setTextColor(unpack(params.linkColor1))
				end
			end
			
		elseif(event.phase == "ended") then
			for i = 1, self.numChildren do
				if(self[i].isText) then
					self[i]:setTextColor(unpack(params.linkColor2))
				end
			end

			if(self.href) then
				system.openURL(self.href) -- EFM
				Runtime:dispatchEvent( { name = "onChoice", choice = self.href } )
			end

		end
		return true
	end

	local r_mltext

	r_mltext = function( r_twords, group, r_params  )

		for i = 1, #r_twords do
			local word = r_twords[i]
						
			local tmp
			if(type(word) == "string") then
				--print("EFM", "::"..word.."::", r_params.font, r_params.fontSize)
				tmp = display.newText( group, word, lastX, y, r_params.font, r_params.fontSize)
				tmp:setTextColor(unpack( r_params.fontColor) )
				tmp.isText = true
				
			elseif( word._tag == "br" ) then 
				y = y + r_params.lineHeight
				lastX = startX
			
			elseif( word._tag == "a" ) then
				local lParams = shallowCopy( r_params )
				lParams.fontColor =  r_params.linkColor1

				local tmpGroup = display.newGroup()
				group:insert(tmpGroup)

				r_mltext( word, tmpGroup, lParams )

				tmpGroup.touch = onTouch
				tmpGroup:addEventListener("touch", tmpGroup)
				tmpGroup.href = word._attr.href	

				--tmpGroup.isVisible = false

			elseif( word._tag == "img" ) then
				local src = word._attr.src
				local height = word._attr.height
				local width = word._attr.width
				local xOffset = word._attr.xOffset or 0
				local yOffset = word._attr.yOffset or 0

				if(height and not width) then width = height end
				if(width and not height) then height = width end

				if(not width) then
					tmp = display.newImage( group, src, lastX, y )
					tmp:translate( xOffset, yOffset )

				else
					tmp = display.newImageRect( group, src, width, height )
					tmp.x = lastX + tmp.width/2 + xOffset
					tmp.y = y + tmp.height/2 + yOffset
				end
		
			elseif( word._tag == "font" ) then
				local lParams = shallowCopy( r_params )

				if(  word._attr.size ) then
					lParams.fontSize = word._attr.size
				else	
					lParams.fontSize = r_params.fontSize
				end
				
				if(word._attr.color) then 
					lParams.fontColor = colorChart:fromName(word._attr.color, true)
				else
					lParams.fontColor = r_params.fontColor
				end

				if(  word._attr.face ) then
					lParams.font = word._attr.face
				else
					lParams.font = r_params.font
				end

				local tmpGroup = display.newGroup()
				group:insert(tmpGroup)

				r_mltext( word, tmpGroup, lParams )
			end
		
			if(tmp) then
				lastX = lastX + tmp.width + r_params.spaceWidth
			end
		end

		--return group
	end

	r_mltext(twords, group, params)

	return group
end

local public = {}

public.newMLText = newMLText

return public 
