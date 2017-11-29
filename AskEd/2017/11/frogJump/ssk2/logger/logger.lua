-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local logger = {}
local print

local function round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end


local w 				   = display.contentWidth
local h 				   = display.contentHeight
local centerX 			= display.contentCenterX
local centerY 			= display.contentCenterY
local fullw			   = display.actualContentWidth 
local fullh			   = display.actualContentHeight
local unusedWidth		= fullw - w
local unusedHeight	= fullh - h
local deviceWidth		= math.floor((fullw/display.contentScaleX) + 0.5)
local deviceHeight 	= math.floor((fullh/display.contentScaleY) + 0.5)
local left				= 0 - unusedWidth/2
local top 				= 0 - unusedHeight/2
local right 			= w + unusedWidth/2
local bottom 			= h + unusedHeight/2

w 				   = round(w)
h 				   = round(h)
left				= round(left)
top				= round(top)
right			   = round(right)
bottom			= round(bottom)
fullw			   = round(fullw)
fullh			   = round(fullh)

left 			= (left>=0) and math.abs(left) or left
top 				= (top>=0) and math.abs(top) or top

local orientation  	= ( w > h ) and "landscape"  or "portrait"
local isLandscape 		= ( w > h )
local isPortrait 		= ( h > w )

--------------------------------------------------------------------------------
-- CONVERT TABLE TO STRING
-- From Jason Schroeder's Twitter Demo
-- http://www.jasonschroeder.com/
--------------------------------------------------------------------------------
function table.toString ( t, flat )
	local output = {}
    local print_r_cache={}
    local function sub_print_r(t,indent)
    	local function assemble(string)
    		output[#output + 1] = string
    	end
        if (print_r_cache[tostring(t)]) then
            assemble(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                    	if( flat ) then
                        	assemble(indent..tostring(t).." {")
                        else
                        	assemble(indent.."["..pos.."] => "..tostring(t).." {")
                        end                        
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        assemble(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                    	if( flat ) then
                        	assemble(indent .. val)
                        else
                        	assemble(indent.."["..pos..'] => "'..val..'"')
                        end
                    else
                    	if( flat ) then
                        	assemble(indent .. tostring(val))
                        else
                        	assemble(indent.."["..pos.."] => "..tostring(val))
                        end
                    end
                end
            else
                assemble(indent..tostring(t))
            end
        end
    end
	sub_print_r(t,"  ")
	local tmp = output
	output = ""
	for i = 1, #tmp do
		output = output .. tmp[i]
	end
    return output
end

function table.toString_old( t, flat )
	local output = {}
    local print_r_cache={}
    local function sub_print_r(t,indent)
    	local function assemble(string)
    		output[#output + 1] = string
    	end
        if (print_r_cache[tostring(t)]) then
            assemble(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                    	if( flat ) then
                        	assemble(indent..tostring(t).." {")
                        else
                        	assemble(indent.."["..pos.."] => "..tostring(t).." {")
                        end                        
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        assemble(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                    	if( flat ) then
                        	assemble(indent .. val)
                        else
                        	assemble(indent.."["..pos..'] => "'..val..'"')
                        end
                    else
                    	if( flat ) then
                        	assemble(indent .. tostring(val))
                        else
                        	assemble(indent.."["..pos.."] => "..tostring(val))
                        end
                    end
                end
            else
                assemble(indent..tostring(t))
            end
        end
    end
	sub_print_r(t,"  ")
    return output
end




-- ==
--    string:rpad( len, char ) - Places padding on right side of a string, such that the new string is at least len characters long.
-- ==
function string_rpad( theStr, len, char)
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end



function logger.dump(theTable, padding, marker ) -- Sorted
	marker = marker or ""
	theTable = theTable or  {}
	local function compare(a,b)
	  return tostring(a) < tostring(b)
	end
	local tmp = {}
	for n in pairs(theTable) do table.insert(tmp, n) end
	table.sort(tmp,compare)

	padding = padding or 30
	print("\Table Dump:")
	print("-----")
	if(#tmp > 0) then
		for i,n in ipairs(tmp) do 		

			local key = tmp[i]
			local value = tostring(theTable[key])
			local keyType = type(key)
			local valueType = type(value)
			local keyString = tostring(key) .. " (" .. keyType .. ")"
			local valueString = tostring(value) .. " (" .. valueType .. ")" 

			keyString = string_rpad(keyString ,padding)
			valueString = string_rpad(valueString, padding)

			print( keyString .. " == " .. valueString ) 
		end
	else
		print("empty")
	end
	print( marker .. "-----\n")
end


-- ==
--    table.print_r( theTable ) - Dumps indexes and values inside multi-level table (for debug)
-- ==
function logger.print_r( t ) 
	--local depth   = depth or math.huge
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+1))
						print(indent..string.rep(" ",string.len(pos)+1).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end			
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t," ")
		print("}")
	else
		sub_print_r(t," ")
	end
end

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------






local json = require "json"
local _print = _G.print

local logFont 

local systemFonts = native.getFontNames()
table.sort(systemFonts)

-- Display each font in the Terminal/console
for i, fontName in ipairs( systemFonts ) do
	local tmp = fontName
	tmp = fontName:gsub( "% ", "" )
	tmp = tmp:gsub( "%-", "" )
	--print( i, fontName, tmp)
	if( tmp:lower() == "courier" ) then
		logFont = fontName
	elseif( tmp:lower() == "couriernew" ) then
		logFont = fontName
	end
end





--logger._print = _print



logger.data = {}

logger.print= function( ... )

--_G.print = function( ... )

	local inString = ""	
	for i = 1, #arg do
		local dataToShow = arg[i] 
		local resultType = type(dataToShow)
		--_print( "ARG", i, resultType )
		
		if resultType == "table" then
			--_print(i, "In Table convert")
			dataToShow = table.toString(dataToShow,true)
		--elseif( resultType == "boolean" ) then
			--dataToShow = tostring( dataToShow )
		--elseif( resultType == "number" ) then
			--dataToShow = tostring( dataToShow )
		elseif( resultType ~= "string" ) then
			dataToShow = tostring( dataToShow )
		else
			local jsonDecoded = json.decode(dataToShow)
			if jsonDecoded ~= nil then
				--_print(i, "In Other convert")
				dataToShow = table.toString(dataToShow,true)
			
			else 
				--_print(i, "In String no-convert")	
			end
		end
		--_print(i, type(dataToShow), resultType )
		if( inString:len() > 0 ) then
			inString = inString .. " " .. dataToShow
		else
			inString = string.format( "%6.6d : %s" , system.getTimer(), dataToShow )
		end
	end
	--_print("BOB" , inString )

	logger.data[#logger.data + 1] = inString 

	if( #logger.data > 200 ) then
		table.remove(logger.data,1)
	end

	--[[
	local inString = ""	
	for i = 1, #arg do		
		--_print("BOB" , i, arg[i] )

	end
	--]]
	
	_print( unpack(arg) )
end

function logger.purge()
	logger.data = {}
end

-- Doesn't work if called too soon
function logger.hide()
	_print("logger.hide()", logger.doHide)
	if( logger.doHide ) then
		logger.doHide()
	end
end

--------------------------------------------------------------------------------
-- CONVERT TABLE TO STRING
-- From Jason Schroeder's Twitter Demo
-- http://www.jasonschroeder.com/
--------------------------------------------------------------------------------
local frontGroup = display.newGroup()
function frontGroup.enterFrame( self )
   if( not frontGroup  ) then return end
   if( frontGroup.removeSelf == nil ) then
      Runtime:removeEventListener("enterFrame", frontGroup)
      return true
   end      
   frontGroup:toFront()
end
Runtime:addEventListener("enterFrame", frontGroup)

function logger.showCurrentLogs( dataToShow )
	display.remove(frontGroup)
	frontGroup = display.newGroup()
	local resultType = type(dataToShow)
	local json = require "json"
	local widget = require("widget")

	local accumHeight = 0

	if resultType == "table" then
		dataToShow = table.toString_old(dataToShow,true)
	else
		local jsonDecoded = json.decode(dataToShow)
		if jsonDecoded ~= nil then
			dataToShow = table.toString_old(dataToShow,true)
		else
			local text = dataToShow
			dataToShow = {text}
		end
	end
	
	local scrollView = widget.newScrollView({
		width = fullw - 100,
		height = fullh - 100,
		topPadding = 15,
		bottomPadding = 15,
		leftPadding = 15,
		rightPadding = 15,
		x = centerX,
		y = bottom + fullh,
		horizontalScrollDisabled = true,
	})
	scrollView:addEventListener("tap", function() return true end)
	frontGroup:insert(1, scrollView)

	local textObjects = {}

	for i = 1, #dataToShow do
		local text 		= display.newText({
			text 		= dataToShow[i],
			width 		= scrollView.contentWidth - 60,
			font 		= logFont,
			fontSize 	= 14,
		})
		text.anchorX, text.anchorY = 0, 0
		text.x = 30
		if textObjects[i-1] then
			text.y = textObjects[i-1].y + textObjects[i-1].height
		else
			text.y = 0
		end
		scrollView:insert(text)
		text:setFillColor(0)
		textObjects[i] = text
		accumHeight = accumHeight + text.contentHeight
	end

	if( accumHeight > scrollView.contentHeight ) then
		scrollView:scrollTo( "bottom", { time = 1500 } )
	end

	local blackout = display.newRect(frontGroup, centerX, centerY, fullw, fullh)
	blackout:setFillColor(0, 0, 0, .6)
	blackout.alpha = 0
	blackout.isHitTestable = true

	function logger.doHide()

		local function remove()
			display.remove(blackout)
			display.remove(scrollView)
		end

		local function part4()
			scrollView:toBack()
			transition.to(scrollView, {y = bottom + fullh, time = 800, transition = easing.inOutSine, onComplete = remove})
		end

		local function part3()
			transition.to(blackout, { alpha = 0, time = 300, transition = easing.inOutSine})
			transition.to(scrollView, {y = top + fullh*.25, time = 300, transition = easing.inOutSine, onComplete = part4})
		end

		if blackout.alpha == 1 then
			blackout.tap = function() return true end
			part3()
		end
		--logger.doHide = nil

		logger.isOpen = false
		return true
	end
	blackout.tap = logger.doHide
	blackout:addEventListener("tap")
	blackout:addEventListener("touch", function() return true end)

	local function part2()
		scrollView:toFront()
		transition.to(scrollView, {y = centerY, time = 300, transition = easing.inOutSine, onComplete = part3})
		transition.to(blackout, {alpha = 1})
	end

	transition.to(scrollView, {y = top + fullh*.25, time = 800, transition = easing.inOutSine, onComplete = part2})
end


logger.isOpen = false
logger.ignoringOpenHide = false

function logger.show()
	-- Prevent open-close spamming
	--
	if( logger.ignoringOpenHide ) then 
		return 
	end
	logger.ignoringOpenHide = true
	timer.performWithDelay( 2000,
		function()
			logger.ignoringOpenHide = false
		end )


	-- Already open?  Close it
	if( logger.isOpen ) then 
		logger.hide()
		return 
	end

	-- Open it.
	logger.isOpen = true
	logger.showCurrentLogs( logger.data )
end


local unhandledErrorListener = function( event )
    print("unhandledError:\n", event.errorMessage)
    --table.print_r( event )
end
Runtime:addEventListener( "unhandledError", unhandledErrorListener )

print = logger.print

--print("============================================")
--print("Selected logFont == ", logFont )
--print("============================================\n")

return logger