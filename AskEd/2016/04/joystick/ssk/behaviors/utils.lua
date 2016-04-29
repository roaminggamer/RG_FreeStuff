-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
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

utils = {}

--- Add Multiple Listeners for same Event
function utils.listen( event, obj, listener )
   local hname = "__" .. event
   listeners = obj[hname] or {}
   obj[hname] = listeners   
   if( #listeners == 0 ) then
      obj[event] = function( self, event )
         local retval = true
         for i = 1, #listeners do
            local func = listeners[i]
            local ret = func(self,event)
            retval = retval and ((ret ~= nil) and ret or ret)
         end
         return retval
      end
      Runtime:addEventListener( event, obj )
   end
   listeners[#listeners+1] = listener
end

--- Stop listening for specific stacked listener
function utils.ignore( event, obj, listener )
   local hname = "__" .. event
   listeners = obj[hname] or {}
   obj[hname] = listeners   
   table.removeByRef(listeners, listener)   
   if( #listeners == 0 and type(obj[event]) == "function" ) then
      Runtime:removeEventListener( event, obj )
      obj[event] = nil
      return
   end  
end


--- Add Multiple Listeners for same Event
function utils.listenO( event, obj, listener )
   local hname = "__" .. event
   listeners = obj[hname] or {}
   obj[hname] = listeners   
   if( #listeners == 0 ) then
      obj[event] = function( self, event )
         local retval = true
         for i = 1, #listeners do
            local func = listeners[i]
            local ret = func(self,event)
            retval = retval and ((ret ~= nil) and ret or ret)
         end
         return retval
      end
      obj:addEventListener( event )
   end
   listeners[#listeners+1] = listener
end

--- Stop listening for specific stacked listener
function utils.ignoreO( event, obj, listener )
   local hname = "__" .. event
   listeners = obj[hname] or {}
   obj[hname] = listeners   
   table.removeByRef(listeners, listener)   
   if( #listeners == 0 and type(obj[event]) == "function" ) then
      obj:removeEventListener( event )
      obj[event] = nil
      return
   end  
end



-- ==
-- EFM: Remove me when dependencies are removed in behavior(s) that use this
-- ==
function utils.processEvent( obj, event, doDeltas, doTouchVec, doTouchAngle )

	local doDeltas     = doDeltas or false
	local doTouchAngle = doTouchAngle or false
	local doTouchVec   = doTouchVec or doTouchAngle or false

	if(event.phase == "began") then	
		obj.isActive = true

		obj.startX, obj.startY = event.xStart, event.yStart
		obj.lastX, obj.lastY   = obj.curX, obj.curY
		obj.curX, obj.curY     = event.x, event.y

		obj.startTime          = event.time
		obj.activeTime         = 0
		obj.lastInputTime      = event.time
		obj.inputTime          = event.time
		obj.deltaTime          = 0

		-- Calculate deltas between last input and current input
		if(doDeltas) then
			obj.deltaX,obj.deltaY = 0,0
			obj.deltaLen          = 0
		end

		-- Calculate touch vector:  startXY ------> curXY
		if(doTouchVec) then
			obj.touchVecX,obj.touchVecY = 0,0
			obj.touchVecLen             = 0
		end

		-- Calculate angle of touch vector:  startXY ------> curXY
		if(doTouchAngle) then
			obj.touchAngle = 0
		end		

	elseif(event.phase == "moved" or event.phase == "ended" or event.phase == "cancelled") then	
		obj.startX, obj.startY = event.xStart, event.yStart
		obj.lastX, obj.lastY   = obj.curX, obj.curY
		obj.curX, obj.curY     = event.x, event.y

		obj.activeTime         = event.time - obj.startTime
		obj.lastInputTime      = obj.inputTime
		obj.inputTime          = event.time
		obj.deltaTime          = obj.inputTime - obj.lastInputTime

		-- Calculate deltas between last input and current input
		if(doDeltas) then
			obj.deltaX,obj.deltaY = ssk.math2d.sub(obj.lastX, obj.lastY, obj.curX, obj.curY )
			obj.deltaLen          = ssk.math2d.length(obj.deltaX,obj.deltaY)
		end

		-- Calculate touch vector:  startXY ------> curXY
		if(doTouchVec) then
			obj.touchVecX,obj.touchVecY = ssk.math2d.sub(obj.startX, obj.startY, obj.curX, obj.curY )
			obj.touchVecLen             = ssk.math2d.length(obj.touchVecX,obj.touchVecY)
		end

		-- Calculate angle of touch vector:  startXY ------> curXY
		if(doTouchAngle) then
			local nx,ny    = ssk.math2d.normalize(obj.touchVecX,obj.touchVecY) -- EFM necessary?
			obj.touchAngle = ssk.math2d.vector2Angle(nx,ny)
		end
	end
end


return utils
