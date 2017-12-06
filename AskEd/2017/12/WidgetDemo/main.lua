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
-- Support Graphics 2.0
--*********************************************************************************************

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Set the background to white
display.setDefault( "background", 1 )	-- white

-- Require the widget & Composer libraries
local widget = require( "widget" )
local composer = require( "composer" )
local json = require( "json" )

local themeIDs = {
					"widget_theme_android_holo_dark",
					"widget_theme_android_holo_light",
					--"widget_theme_android",
					"widget_theme_ios7",
					--"widget_theme_ios", 
				}
local themeNames = {
					"Android Holo Dark",
					"Android Holo Light",
					--"Android 2.x",
					"iOS7+",
					--"iOS6"
				}

local function showWidgets( widgetThemeNum )

	local halfW = display.contentCenterX
	local halfH = display.contentCenterY
	local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)

	-- Create title bar at top of the screen
	local titleGradient = {
		type = 'gradient',
		color1 = { 189/255, 203/255, 220/255, 1 }, 
		color2 = { 89/255, 116/255, 152/255, 1 },
		direction = "down"
	}
	local titleBar = display.newRect( halfW, 0, display.contentWidth+ox+ox, 32 )
	titleBar:setFillColor( titleGradient )
	titleBar.y = titleBar.contentHeight * 0.5 - oy

	local titleText = display.newText( "Widget Demo - "..themeNames[widgetThemeNum], halfW, titleBar.y, native.systemFont, 14 )

	if ( themeIDs[widgetThemeNum] ~= auto ) then
		-- Set theme based on user selection
		widget.setTheme( themeIDs[widgetThemeNum] )

		-- Store theme in Composer variable for use elsewhere
		composer.setVariable( "themeID", themeIDs[widgetThemeNum] )
		
		-- Change background color depending on theme
		if ( themeIDs[widgetThemeNum] == "widget_theme_ios" or themeIDs[widgetThemeNum] == "widget_theme_android" ) then
			display.setDefault( "background", 197/255, 204/255, 212/255, 1 )
		elseif ( themeIDs[widgetThemeNum] == "widget_theme_android_holo_light" ) then
			display.setDefault( "background", 248/255 )
		elseif ( themeIDs[widgetThemeNum] == "widget_theme_android_holo_dark" ) then
			display.setDefault( "background", 34/255 )
		end
	end

	-- Create buttons table for the tabBar
	local tabButtons = 
	{
		{
			label = "TableView",
			onPress = function() composer.gotoScene( "tab1" ); end,
			selected = true
		},
		{
			label = "Picker",
			onPress = function() composer.gotoScene( "tab3" ); end,
		},
		{
			label = "ScrollView",
			onPress = function() composer.gotoScene( "tab2" ); end,
		},
		{
			label = "Other",
			onPress = function() composer.gotoScene( "tab4" ); end,
		}
	}

	-- Create tabBar at bottom of the screen
	local tabBar = widget.newTabBar
	{
		top = display.contentHeight,
		width = display.contentWidth+ox+ox,
		buttons = tabButtons
	}
	tabBar.x = halfW
	tabBar.y = display.contentHeight - (tabBar.height/2) + oy
	
	-- Store tabBar height in Composer variable
	composer.setVariable( "tabBarHeight", tabBar.height )
	
	-- Start at tab1
	composer.gotoScene( "tab1" )
end

local function themeChooser( event )
	--print( "themeChooser: "..json.encode(event) )

	local chosenTheme = event.index
	if chosenTheme < 1 then
		-- Default to the first theme choice if one wasn't made (event.index == 0).
		chosenTheme = 1
	end
	showWidgets( chosenTheme )
end

native.showAlert( "Choose Theme", "Widgets can be skinned to look like different device OS versions.", themeNames, themeChooser )
