-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

-- EFM - This should be achievable w/ a resize event and size re-calculation
--[[
local statusBarStatus
local display_setStatusBar = display.setStatusBar
-- display.setStatusBar()
--
display.setStatusBar = function( setting )
	statusBarStatus = setting
	display_setStatusBar( setting )
	if( setting == display.HiddenStatusBar and not onSimulator) then
		_G.top = 0 - unusedHeight/2 - display.topStatusBarContentHeight
	else
		_G.top = 0 - unusedHeight/2
	end
end
display.getStatusBar = function( )
	return statusBarStatus
end
--]]

if( ssk.enableExperimental ) then

	-- display.remove( func ) - Replacement that works in tandem with 'isValid'
	--
	display._remove = display.remove
	display.remove = function ( obj )
		if( not obj or  obj.__destroyed ) then return end
		if(obj.__autoClean) then
			obj:__autoClean()
			obj__autoClean = nil
		end
		display._remove( obj )
		obj.__destroyed = true
	end

	-- display.remove( func ) - Replacement that works in tandem with 'isValid'
	--
	display.isValid = function ( obj )
		return( obj and 
			    not obj.__destroyed and 
			    obj.removeSelf ~= nil )
	end

	-- removeWithDelay( func ) - Remove an object in the next frame or after delay
	--
	function display.removeWithDelay( obj, delay )
	    delay = delay or 1    
	    timer.performWithDelay(delay, 
	        function() 
	            display.remove( obj )
	        end )
	end

	--
	-- Auto Cleaner Code - Removes table and runtime event listeners from this object, removes body, and kill last timer if found.
	--
	local physics = require "physics"
	local runtimeListeners = { "enterFrame" }
	local function autoCleaner( self )
		local tableListeners = self._tableListeners or {}
		for k, v in pairs( tableListeners ) do
			self:removeEventListener( k, v )
			self[v] = nil
		end

		-- Remove Runtime listeners	
		local runtimeListeners = self.__runtimeListeners or {}
		if( runtimeListeners ) then
			for k, v in pairs( runtimeListeners ) do
				ignore( k, v )
				runtimeListeners[k] = nil
			end
		else 
			--print("Warning Function Listener") -- EFM dig into this case
		end
		-- timer
		if( self.__myTimer ) then
			timer.cancel( self.__myTimer )
			self.__myTimer = nil
		elseif( self.timer ) then
			self.timer = function() end
		end
		-- Body
		if( self.__hasBody ) then		
			physics.removeBody( self )
		end
		--print( self, "autoCleaner @ ", system.getTimer() )
	end

	-- Runtime Listeners
	--
	local Runtime_addEventListener = Runtime.addEventListener
	Runtime.addEventListener = function( self, eventName, listener )
		Runtime_addEventListener( self, eventName, listener )	
		if( type( listener ) == "table" )  then
			if( listener.__runtimeListeners == nil ) then
				listener.__runtimeListeners = {}
			end
			listener.__runtimeListeners[eventName] = listener
		end
	end
	local function genAutoCleaner( library, funcName )
		local oldFunc = library[funcName]
		library[funcName] = function( ... )
			local obj = oldFunc( unpack( arg ) )
			obj.__autoClean = autoCleaner
			return obj
		end
	end
	genAutoCleaner( display, "newCircle" )
	genAutoCleaner( display, "newContainer" )
	genAutoCleaner( display, "newEmbossedText" )
	genAutoCleaner( display, "newEmitter" )
	genAutoCleaner( display, "newGroup" )
	genAutoCleaner( display, "newImage" )
	genAutoCleaner( display, "newImageRect" )
	genAutoCleaner( display, "newLine" )
	genAutoCleaner( display, "newPolygon" )
	genAutoCleaner( display, "newRect" )
	genAutoCleaner( display, "newRoundedRect" )
	genAutoCleaner( display, "newSnapshot" )
	genAutoCleaner( display, "newSprite" )
	genAutoCleaner( display, "newText" )
	-- Timers
	local timer_performWithDelay = timer.performWithDelay
	timer.performWithDelay = function( delay, listener, iterations )
		iteration = iterations or 1
		if( type(listener) == "function" ) then
			return timer_performWithDelay( delay, listener, iterations )
		else
			listener.__myTimer = timer_performWithDelay( delay, listener, iterations )
			return listener.__myTimer
		end
	end
	-- Physics
	--
	local physics_addBody = physics.addBody

	physics.addBody = function( obj, ... )
		obj.__hasBody = physics_addBody( obj, unpack( arg ) )
		return obj.__hasBody
	end

	-- ==
	--		pushDisplayDefault() / popDisplayDefault()- 
	-- ==
	local defaultValues = {}
	function display.pushDisplayDefault( defaultName, newValue )
		if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
		local values = defaultValues[defaultName]
		values[#values+1] = display.getDefault( defaultName )
		display.setDefault( defaultName, newValue )
	end

	function display.popDisplayDefault( defaultName )
		if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
		local values = defaultValues[defaultName]
		if(#values == 0) then return end

		local tmp = values[#values]
		values[#values] = nil
		display.setDefault( defaultName, tmp )
	end



	-- AUTO CLEAN TEST CODE
	--[[

	local test = display.newCircle( 100, 100, 10 )
	test.myName = "Bill"
	test.touch = function( self, event )
	end
	test:addEventListener("touch")


	test.enterFrame = function( self )
		print("In enterframe ", system.getTimer())
	end

	listen( "enterFrame", test )

	--table.print_r(test)

	test.timer = 	function( self ) 
			print("Do remove @  ", system.getTimer() )
			display.remove( self ) 
			post("onBob")
			--table.print_r( self )
		end
	timer.performWithDelay( 500, test )

	test.onBob = function( self )
		print(self.myName)
		table.print_r(self)
	end; listen( "onBob", test )

	post("onBob")
	--]]	
else
	-- display.remove( func ) - Replacement that works in tandem with 'isValid'
	--
	display.isValid = function ( obj )
		return( obj and obj.removeSelf ~= nil )
	end

end