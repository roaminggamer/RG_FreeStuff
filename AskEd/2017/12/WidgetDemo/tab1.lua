--*********************************************************************************************
--
-- ====================================================================
-- Corona "Widget" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 2.0
--
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Published changes made to this software and associated documentation and module files (the
-- "Software") may be used and distributed by Corona Labs, Inc. without notification. Modifications
-- made to this software and associated documentation and module files may or may not become
-- part of an official software release. All modifications made to the software will be
-- licensed under these same terms and conditions.
--
-- Supports Graphics 2.0
--*********************************************************************************************

display.setDefault( "background", 1, 0, 1 ) -- RG

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

-- Create scene
function scene:create( event )
	local sceneGroup = self.view
	local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
	local tabBarHeight = composer.getVariable( "tabBarHeight" )
	local themeID = composer.getVariable( "themeID" )

	-- Set color variables depending on theme
	local tableViewColors = {
		--rowColor = { default = { 1 }, over = { 30/255, 144/255, 1 } }, -- RG
		rowColor = { default = { 1,1,1,0 }, over = { 30/255, 144/255, 1 } },  -- RG
		lineColor = { 220/255 },
		catColor = { default = { 150/255, 160/255, 180/255, 200/255 }, over = { 150/255, 160/255, 180/255, 200/255 } },
		defaultLabelColor = { 0, 0, 0, 0.6 },
		catLabelColor = { 0 }
	}
	if ( themeID == "widget_theme_android_holo_dark" ) then
		tableViewColors.rowColor.default = { 48/255 }
		tableViewColors.rowColor.over = { 72/255 }
		tableViewColors.lineColor = { 36/255 }
		tableViewColors.catColor.default = { 80/255, 80/255, 80/255, 0.9 }
		tableViewColors.catColor.over = { 80/255, 80/255, 80/255, 0.9 }
		tableViewColors.defaultLabelColor = { 1, 1, 1, 0.6 }
		tableViewColors.catLabelColor = { 1 }
	elseif ( themeID == "widget_theme_android_holo_light" ) then
		tableViewColors.rowColor.default = { 250/255 }
		tableViewColors.rowColor.over = { 240/255 }
		tableViewColors.lineColor = { 215/255 }
		tableViewColors.catColor.default = { 220/255, 220/255, 220/255, 0.9 }
		tableViewColors.catColor.over = { 220/255, 220/255, 220/255, 0.9 }
		tableViewColors.defaultLabelColor = { 0, 0, 0, 0.6 }
		tableViewColors.catLabelColor = { 0 }
	end
	
	-- Forward reference for the tableView
	local tableView
	
	-- Text to show which item we selected
	local itemSelected = display.newText( "User selected row ", 0, 0, native.systemFont, 16 )
	itemSelected:setFillColor( unpack(tableViewColors.catLabelColor) )
	itemSelected.x = display.contentWidth+itemSelected.contentWidth
	itemSelected.y = display.contentCenterY
	sceneGroup:insert( itemSelected )
	
	-- Function to return to the tableView
	local function goBack( event )
		transition.to( tableView, { x=display.contentWidth*0.5, time=600, transition=easing.outQuint } )
		transition.to( itemSelected, { x=display.contentWidth+itemSelected.contentWidth, time=600, transition=easing.outQuint } )
		transition.to( event.target, { x=display.contentWidth+event.target.contentWidth, time=480, transition=easing.outQuint } )
	end
	
	-- Back button
	local backButton = widget.newButton {
		width = 128,
		height = 32,
		label = "back",
		onRelease = goBack
	}
	backButton.x = display.contentWidth+backButton.contentWidth
	backButton.y = itemSelected.y+itemSelected.contentHeight+16
	sceneGroup:insert( backButton )
	
	-- Listen for tableView events
	local function tableViewListener( event )
		local phase = event.phase
		--print( "Event.phase is:", event.phase )
	end

	-- Handle row rendering
	local function onRowRender( event )
		local phase = event.phase
		local row = event.row

		local groupContentHeight = row.contentHeight
		
		local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
		rowTitle.x = 10
		rowTitle.anchorX = 0
		rowTitle.y = groupContentHeight * 0.5
		if ( row.isCategory ) then
			rowTitle:setFillColor( unpack(row.params.catLabelColor) )
			rowTitle.text = rowTitle.text.." (category)"
		else
			rowTitle:setFillColor( unpack(row.params.defaultLabelColor) )
		end
	end
	
	-- Handle row updates
	local function onRowUpdate( event )
		local phase = event.phase
		local row = event.row
		--print( row.index, ": is now onscreen" )
	end
	
	-- Handle touches on the row
	local function onRowTouch( event )
		local phase = event.phase
		local row = event.target
		if ( "release" == phase ) then
			itemSelected.text = "User selected row " .. row.index
			transition.to( tableView, { x=((display.contentWidth/2)+ox+ox)*-1, time=600, transition=easing.outQuint } )
			transition.to( itemSelected, { x=display.contentCenterX, time=600, transition=easing.outQuint } )
			transition.to( backButton, { x=display.contentCenterX, time=750, transition=easing.outQuint } )
		end
	end
	
	-- Create a tableView
	tableView = widget.newTableView
	{
		top = 32-oy,
		left = -ox,
		width = display.contentWidth+ox+ox, 
		height = display.contentHeight-tabBarHeight+oy+oy-32,
		hideBackground = true,
		listener = tableViewListener,
		onRowRender = onRowRender,
		onRowUpdate = onRowUpdate,
		onRowTouch = onRowTouch,
	}
	sceneGroup:insert( tableView )

	-- Create 75 rows
	for i = 1,75 do
		local isCategory = false
		local rowHeight = 32
		local rowColor = { 
			default = tableViewColors.rowColor.default,
			over = tableViewColors.rowColor.over,
		}
		-- Make some rows categories
		if i == 20 or i == 40 or i == 60 then
			isCategory = true
			rowHeight = 32
			rowColor = {
				default = tableViewColors.catColor.default,
				over = tableViewColors.catColor.over
			}
		end
		-- Insert the row into the tableView
		tableView:insertRow
		{
			isCategory = isCategory,
			rowHeight = rowHeight,
			rowColor = rowColor,
			lineColor = tableViewColors.lineColor,
			params = { defaultLabelColor=tableViewColors.defaultLabelColor, catLabelColor=tableViewColors.catLabelColor }
		}
	end
end

scene:addEventListener( "create" )

return scene
