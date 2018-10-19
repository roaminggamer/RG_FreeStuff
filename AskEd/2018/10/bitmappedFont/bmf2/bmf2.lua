--  bmGlyph and Corona with graphics 2.0
--  support unicode
--  based on the bmf.lua version found on the corona forum and a modified utf8.lua lib
--	Supports Graphics 2.0


module( ..., package.seeall )
local utf8 = require('bmf_utf8')

--
function loadFont( fntFile )
	local suffix
	if display.imageSuffix == nil then
		suffix = ""
	else
		suffix = display.imageSuffix
	end
	local fontDef = require(fntFile..suffix)
	local options =
	{
		frames = fontDef.frames,
	}
  	local fontSheet = graphics.newImageSheet( fntFile .. ".png", options )
	local newFont ={}
	newFont.sheet = fontSheet
	newFont.mapping = fontDef.mapping
	if fontDef.kernings then
		newFont.kernings = fontDef.kernings
	else
		newFont.kernings = {}
	end
	
	newFont.frames = fontDef.frames
	newFont.info = fontDef.info
  	return newFont
end

--find the sheet index for the unicode char
function sheetIndexForChar(font,c)
	local index
	if (c) then
		index = font.mapping[tostring(c)]
	else
		index = nil
	end
	return index
end

-- extend an object with accessor behaviors
local function accessorize( t )
  local mt = getmetatable( t )
  setmetatable( t, {
    __index = function( t, k )
      if rawget( t, 'get_'..k ) then
        return rawget(t, 'get_'..k )( t, k )
      elseif rawget( t, 'raw_'..k ) then
	      return rawget( t, 'raw_'..k )
      elseif mt.__index then
        return mt.__index( t, k )
      else
        return nil
	    end
    end,
    __newindex = function( t, k, v )
		  if rawget( t, 'set_'..k ) then
		    rawget( t, 'set_'..k )( t, k, v )
	    elseif rawget( t, 'raw_'..k ) then
	      rawset( t, 'raw_'..k, v )
	    elseif mt.__newindex then
	      mt.__newindex( t, k, v )
	    else
	      rawset( t, 'raw_'..k, v )
	    end
    end,
  } )
end

-- extend an object with cascading removeSelf
local function removerize( t )
  local old = t.removeSelf
  t.removeSelf = function( o )
    for i = o.numChildren, 1, -1 do o[ i ]:removeSelf() end
    old( o )
  end
end

-- Pass a font object (obtained from loadFont) and a string to render
-- Return value is a DisplayObject of the rendered string
-- object.font can be read/modifed
-- object.text can be read/modified
-- object.align can be read/modified - left/right/center (multiline not yet fully supported for non-left)
-- object.input( function(text), { filter = function(), max = 32 } )
--   turns the object into a text input.
--   the callback is hit when the user presses "return" or the field losed focus.
--   this code is under development - more documentation will be added soon...
function newString( font, text, align )
  local obj = display.newGroup()
  obj.anchorChildren = true
  accessorize( obj )
  removerize( obj )
  obj.set_font = function( t, k, v )
    obj.raw_font = v
    if t.text then t.text = t.text end
  end
  obj.set_align = function( t, k, v )
  		print('set_align', t, k, v )
		local w = t.contentWidth
		if t.raw_align == 'right' then
			for i = 1, t.numChildren do
				t[ i ].x = t[ i ].x - w
			end
		elseif t.raw_align == 'center' then
			for i = 1, t.numChildren do
				print(t[ i ].x)
				t[ i ].x = t[ i ].x + math.floor( w * 0.5 )
				print(t[ i ].x)
			end
		end
		t.raw_align = v
		if t.raw_align == 'right' then
			for i = 1, t.numChildren do
				t[ i ].x = t[ i ].x + w
			end
		elseif t.raw_align == 'center' then
			for i = 1, t.numChildren do
			  t[ i ].x = t[ i ].x - math.floor( w * 0.5 )
			end
		elseif t.raw_align ~= 'left' then
			t.raw_align = 'left'
		end
  end
  obj.set_text = function( t, k, v )
		t.raw_text = v
		
		for i = t.numChildren, 1, -1 do t[i]:removeSelf() end
		local oldAlign = ( t.align or 'left' )
		t.align = align or 'left'
		local x = 0; local y = 0
		local last = 0; local xMax = 0; local yMax = 0
		local unicode = 0
		if t.raw_font then
			--if display.contentScaleX == .5 then 
			--	t.raw_font.info.lineHeight = t.raw_font.info.lineHeight /2
			--end
		
			for i, c, b in utf8.chars(t.raw_text) do
   				unicode = utf8.unicodeValue(c)
				if c == '\n' then
					x = 0; 
					y = y + t.raw_font.info.lineHeight *display.contentScaleX
					if y >= yMax then
						yMax = y
					end
				elseif t.raw_font.mapping[ tostring(unicode) ] then	
					local fntFrame = t.raw_font.frames[sheetIndexForChar(t.raw_font,unicode)]
					if (fntFrame) then
					--print (t.raw_font.frames[sheetIndexForChar(c)].width)
					if 0 + t.raw_font.frames[sheetIndexForChar(t.raw_font,unicode)].width > 0 and 0 + t.raw_font.frames[sheetIndexForChar(t.raw_font,unicode)].height > 0 then
						--local letter = sprite.newSprite( t.raw_font.sprites[ c ] )
						local spriteOptions = { name=tostring(unicode), start=sheetIndexForChar(t.raw_font,unicode), count=1 }
						--print ("spriteOptions "..name.." "..start)
						local letter = display.newSprite( t.raw_font.sheet, spriteOptions )
						
						letter.anchorX = 0
						letter.anchorY = 0
						letter.x = 0
						letter.y = 0
						--:setReferencePoint( display.TopLeftReferencePoint )
						if (last ~= 0) then
						--print ("k: "..tostring(last) ..",".. tostring(unicode))
						if t.raw_font.kernings[ tostring(last) ..",".. tostring(unicode) ] then
							--print "kern"
							x = x + font.kernings[ tostring(last) ..",".. tostring(unicode)  ] * display.contentScaleX
						end
						end
						--print (display.contentScaleX .." " ..letter.width)
						letter.width = letter.width*display.contentScaleX
						letter.height = letter.height*display.contentScaleY
						--if display.contentScaleX == .5 then --scale the highres spritesheet if you're on a retina device.
						
						--	letter.xScale = .5
						--	letter.yScale = .5
						--	letter.x = t.raw_font.frames[ sheetIndexForChar(t.raw_font,unicode) ].xoffset/2 + x
						--	letter.y = t.raw_font.frames[ sheetIndexForChar(t.raw_font,unicode) ].yoffset/2 - t.raw_font.info.base + y
						--else
							letter.x = t.raw_font.frames[ sheetIndexForChar(t.raw_font,unicode) ].xoffset *display.contentScaleX + x
						    letter.y = t.raw_font.frames[ sheetIndexForChar(t.raw_font,unicode) ].yoffset *display.contentScaleX - t.raw_font.info.base + y
						--end
						
						t:insert( letter )
						last = unicode
					end
					
					--if display.contentScaleX == .5 then 
					--	x = x + t.raw_font.frames[ sheetIndexForChar(t.raw_font,unicode) ].xadvance/2
					--else
						x = x + t.raw_font.frames[ sheetIndexForChar(t.raw_font,unicode) ].xadvance *display.contentScaleX
					--end
					if x >= xMax then
						xMax = x
					end
					end
				end
			end
		  local background = display.newRect( 0, -t.raw_font.info.base, xMax, yMax )
		  obj:insert( background )
		  background:setFillColor( 0, 0, 0, 0 )
		end
		t.align = oldAlign
	end
	obj.input = function( f, args )
		-- spawn the text field invisibly
		local field
		local function char()
			-- check if any character has been added or deleted
			if field.text ~= '--' then
				if string.len( field.text ) < 2 then
					-- backspace was pressed
					if string.len( obj.text ) > 0 then
						obj.text = string.sub( obj.text, 1, -2 )
					end
				else
					-- some other key was pressed
					obj.text = obj.text..string.sub( field.text, 3 )
				end
				field.text = '--'
				if args.filter then
					obj.text = string.sub( args.filter( obj.text ), 1, (args.max or 32) )
				else
					obj.text = string.sub( obj.text, 1, (args.max or 32) )
				end
			end
		end
		Runtime:addEventListener( 'enterFrame', char )
		local function done( e )
			if e.phase == 'submitted' or e.phase == 'ended' then
				native.setKeyboardFocus( nil )
				field:removeSelf()
				Runtime:removeEventListener( 'enterFrame', char )
				f( text )
			end
		end
		field = native.newTextField( 0, 0, 240, 24, done )
		field.text = '--'
		field.isVisible = false
		native.setKeyboardFocus( field )
	end
	obj.font = font
	obj.align = align or 'left'
  obj.text = (text or '')
  return obj
end
