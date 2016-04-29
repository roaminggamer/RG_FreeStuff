-- =============================================================
-- b_mover_dpad.lua 
-- Mover Behavior - dpad Object (Self)
-- Behavior Type: Instance
-- =============================================================
--
-- =============================================================

--[[ 
     FUNCTIONS IN THIS FILE
--]]
--behaviors = require("behaviors")

public = {}
public._behaviorName = "mover_dpad"

function public:createInputObj( group, region, params )
	
--[[
	w = display.contentWidth
	h = display.contentHeight
	centerX = w/2
	centerY = h/2
--]]
	local region = region or "user"

	local params = params or {}	
	local rgnParams = {}

	rgnParams.trans = params.rTrans or 64

	if(region == "full") then
		rgnParams.w = w
		rgnParams.h = h
		rgnParams.x = centerX
		rgnParams.y = centerY
	elseif(region == "top") then
		rgnParams.w = w
		rgnParams.h = h/2
		rgnParams.x = centerX
		rgnParams.y = centerY - h/4
	elseif(region == "bot") then
		rgnParams.w = w
		rgnParams.h = h/2
		rgnParams.x = centerX
		rgnParams.y = centerY + h/4
	elseif(region == "left") then
		rgnParams.w = w/2
		rgnParams.h = h
		rgnParams.x = centerX - w/4
		rgnParams.y = centerY
	elseif(region == "right") then
		rgnParams.w = w/2
		rgnParams.h = h
		rgnParams.x = centerX + w/4
		rgnParams.y = centerY
	elseif(region == "ul") then
		rgnParams.w = w/2
		rgnParams.h = h/2
		rgnParams.x = centerX - w/4
		rgnParams.y = centerY - h/4
	elseif(region == "ur") then
		rgnParams.w = w/2
		rgnParams.h = h/2
		rgnParams.x = centerX + w/4
		rgnParams.y = centerY - h/4
	elseif(region == "ll") then
		rgnParams.w = w/2
		rgnParams.h = h/2
		rgnParams.x = centerX - w/4
		rgnParams.y = centerY + h/4
	elseif(region == "lr") then
		rgnParams.w = w/2
		rgnParams.h = h/2
		rgnParams.x = centerX + w/4
		rgnParams.y = centerY + h/4

	elseif(region == "llsquare") then
		if(h > w) then
			rgnParams.w = w/2
			rgnParams.h = w/2
			rgnParams.x = w/4
			rgnParams.y = h - w/4
		else
			rgnParams.w = h/2
			rgnParams.h = h/2
			rgnParams.x = h/4
			rgnParams.y = h - h/4
		end

	elseif(region == "lrsquare") then
		if(h > w) then
			rgnParams.w = w/2
			rgnParams.h = w/2
			rgnParams.x = centerX + w/4
			rgnParams.y = h - w/4
		else
			rgnParams.w = h/2
			rgnParams.h = h/2
			rgnParams.x = w - h/4
			rgnParams.y = h - h/4
		end 

	else
		rgnParams.w = params.rWidth or w
		rgnParams.h = params.rHeight or h
		rgnParams.x = params.rX or centerX
		rgnParams.y = params.rY or centerY
	end	
	
	local inputObj = display.newRect(0, 0, rgnParams.w, rgnParams.h)	
	group:insert(inputObj)
	inputObj.x = rgnParams.x
	inputObj.y = rgnParams.y
	inputObj:setFillColor(128, rgnParams.trans)


	local dPadSize = params.dPadSize or 80
	--local imgPath  = params.imgPath or imagesDir .. "dpad.png"
	local imgPath  = imagesDir .. "dpad.png"
	print(imgPath)
	
	--local theDPad = display.newImageRect( group, imgPath, dPadSize, dPadSize )

	local theDPad = display.newImageRect( group, imgPath, 100, 100 ) 
	theDPad.x = inputObj.x
	theDPad.y = inputObj.y


	inputObj.theDPad = theDPad

	return inputObj
end

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)
	local behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName


	-- This method is required (even if it does no work) ==>
	function behaviorInstance:onDetach( obj )
		print("Detached behavior:" .. self._behaviorName)
		-- =========  ADD YOUR DETACH CODE HERE =======

		self.inputObj:removeEventListener( "touch", behaviorInstance )		

		-- =========  ADD YOUR DETACH CODE HERE =======
	end

	-- =========  ADD YOUR ATTACH CODE HERE =======

	if( not params ) then
		params = {}
	end

	-- do initialization work here (like adding functions, fields, etc.)
	behaviorInstance.inputObj = params.inputObj or obj -- Default to this object as input obj
	behaviorInstance.moveObj  = params.moveObj or obj -- Object to move

	-- Enable "touch" listener for for the 'inputObj' and pass these events to the 'behaviorInstance'
	behaviorInstance.inputObj:addEventListener( "touch", behaviorInstance )		

	-- Event listener for touches on 'inputObj'
	function behaviorInstance:touch( event )
		local target      = event.target

		if(event.phase == "began") then
			self.lastX = event.x
			self.lastY = event.y

			display.getCurrentStage():setFocus( target )
			target.isFocus = true

		elseif(target.isFocus) then

			if(event.phase == "ended") then
				self.lastX = nil
				self.lastY = nil
				display.getCurrentStage():setFocus( nil )
				target.isFocus = false

			elseif(event.phase == "moved") then
				if(not self.lastX) then
					return
				end

				local deltaX = event.x - self.lastX
				local deltaY = event.y - self.lastY
				self.lastX = event.x
				self.lastY = event.y

				self.moveObj.x = self.moveObj.x + deltaX
				self.moveObj.y = self.moveObj.y + deltaY
			end
		end
	end

	-- =========  ADD YOUR ATTACH CODE HERE =======
	return behaviorInstance
end


ssk.behaviors:registerBehavior( public._behaviorName, public )
return public
