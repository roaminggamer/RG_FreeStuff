-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local sbc = {}

-- ==
--    sbc.prep_tableRoller( button, srcTable [ , chainedCB [ , underBarSwap ] ])  - Prepares a button to work with the sbc.tableRoller_CB() callback.
-- ==
function sbc.prep_tableRoller( button, srcTable, chainedCB, underBarSwap ) 
	button._entryname = entryName
	button._srcTable = srcTable
	button._chainedCB = chainedCB
	button._underBarSwap = underBarSwap or false	
end

-- ==
--    sbc.tableRoller_CB() - A standard callback designed to work with push buttons.
-- ==
function sbc.tableRoller_CB( event ) 
	local target        = event.target
	local srcTable		= target._srcTable
	local chainedCB     = target._chainedCB
	local underBarSwap  = target._underBarSwap
	local curText       = target:getText()
	local retVal        = true
	local backwards     = event.backwards or false

	if(underBarSwap) then
		curText = curText:spaces2underbars(curText)
	end

	local j
	if( backwards ) then
		--print("Backwards")
		j = #srcTable + 1
		for i = #srcTable, 1, -1 do
			--print(tostring(srcTable[i]) .. " ?= " .. curText )
			if( tostring(srcTable[i]) == curText ) then
				j = i
				break
			end
		end

		j = j - 1

		if(j < 1 ) then
			j = #srcTable
		end
	else
		j = 0
		for i = 1, #srcTable do
			--print(tostring(srcTable[i]) .. " ?= " .. curText )
			if( tostring(srcTable[i]) == curText ) then
				j = i
				break
			end
		end

		j = j + 1

		if(j > #srcTable) then
			j = 1
		end
	end

	if(underBarSwap) then
		target:setText( srcTable[j]:underbars2spaces() )
	else
		target:setText( srcTable[j] )
	end	

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end

-- ==
--    sbc.prep_table2TableRoller( button, dstTable, entryName, srcTable [ , chainedCB ]) - Prepares a button to work with the sbc.table2TableRoller_CB() callback. 
-- ==
function sbc.prep_table2TableRoller( button, dstTable, entryName, srcTable, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._srcTable = srcTable
	button._chainedCB = chainedCB
	button:setText( dstTable[entryName] )
end

-- ==
--    sbc.table2TableRoller_CB() - A standard callback designed to work with push buttons.
-- ==
function sbc.table2TableRoller_CB( event ) 
	local target      = event.target
	local dstTable   = target._dstTable
	local entryName   = target._entryname
	local srcTable = target._srcTable
	local chainedCB   = target._chainedCB
	local curText     = target:getText()
	local retVal      = true

	local j = 0
	for i = 1, #srcTable do
		if( tostring(srcTable[i]) == tostring(curText) ) then
			j = i
			break
		end
	end

	j = j + 1

	if(j > #srcTable) then
		j = 1
	end

	target:setText( srcTable[j] )
	dstTable[entryName] = srcTable[j] 

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end

-- ==
--    sbc.prep_tableToggler( button, dstTable, entryName [ , chainedCB ] ) - Prepares a toggle or radio button to work with the sbc.tableToggler_CB() callback. 
-- ==
function sbc.prep_tableToggler( button, dstTable, entryName, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._chainedCB = chainedCB

	--print("*******************************")
	--print(entryName .. " == " ..  tostring(dstTable[entryName]) )
	if(dstTable[entryName] == true ) then
		button:toggle()
	else
		if( chainedCB ) then
			local dummyEvent = {
				name = touch,
				phase = "ended",
				target = button,
				time = system.getTimer(),
				x = button.x,
				y = button.y,
				xStart = button.x,
				yStart = button.y,
				id = math.random(1000,10000),
			}
			chainedCB( dummyEvent )
		end
	end
end

-- ==
--    sbc.tableToggler_CB() - A standard callback designed to work with toggle and radio buttons.  
-- ==
function sbc.tableToggler_CB( event ) 
	local target      = event.target
	local dstTable   = target._dstTable
	local entryName   = target._entryname
	local chainedCB   = target._chainedCB
	local retVal      = true

	if(not dstTable) then
		return retVal
	end

	dstTable[entryName] = target:pressed() 

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end


-- ==
--    sbc.prep_horizSlider2Table( button, dstTable, entryName [ , chainedCB ] ) - Prepares a slider to work with the sbc.horizSlider2Table_CB() callback. 
-- ==
function sbc.prep_horizSlider2Table( button, dstTable, entryName, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._chainedCB = chainedCB

	local value = dstTable[entryName]

	local knob = button.myKnob

	button:setValue( value )
end

-- ==
--    sbc.horizSlider2Table_CB() - A standard callback designed to work with sliders.  
-- ==
function sbc.horizSlider2Table_CB( event )
	local target     = event.target
	local myKnob     = target.myKnob
	local dstTable   = target._dstTable
	local entryName  = target._entryname
	local chainedCB  = target._chainedCB

	local retVal = true
	local left = (target.x - target.width/2) + myKnob.width/2
	local right = (target.x + target.width/2) - myKnob.width/2
	local top = (target.y - target.width/2) + myKnob.width/2
	local bot = (target.y + target.width/2) - myKnob.width/2
	local height = bot-top
	local width = right-left

	local newX = event.x
	if(newX < left) then
		newX = left
	elseif(newX > right) then
		newX = right
	end

	local newY = event.y
	if(newY < top) then
		newY = top
	elseif(newY > bot) then
		newY = bot
	end

	if( myKnob.rotation == 0 ) then
		myKnob.x = newX
		target.value = (newX-left) / width

	elseif( myKnob.rotation == 90 ) then
			myKnob.y = newY
			target.value = (newY-top) / height
	
	elseif( myKnob.rotation == 180 or myKnob.rotation == -180 ) then
		myKnob.x = newX
		target.value = (width-(newX-left)) / width

	elseif( myKnob.rotation == 270 or myKnob.rotation == -90 ) then
			myKnob.y = newY
			target.value = (height-(newY-top)) / height
	end

	target.value = tonumber(string.format("%1.2f", target.value))

	--print(tostring(entryName) .. " Knob value == " .. target.value)

	if(dstTable and entryName) then
		dstTable[entryName] = target.value 
	end

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end

return sbc