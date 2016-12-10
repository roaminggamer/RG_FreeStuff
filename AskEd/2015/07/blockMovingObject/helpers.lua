-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 
-- =============================================================
-- 
-- =============================================================
local touchJointForce = 500

local helpers = {}

function helpers.setTouchJointForce( force )
	touchJointForce = force
end

function helpers.addNameLabel( group, obj, text )
	local label = display.newText( group, text, obj.x, obj.y, native.systemFont , 16  )
	label:setFillColor(0,0,0)
	label.enterFrame = function( self, event ) 
	    if( self.removeSelf == nil ) then
	    	ignore( "enterFrame", self )
	    	return
	    end
	    self.x = obj.x
	    self.y = obj.y
	    self.rotation = obj.rotation
	end; Runtime:addEventListener( "enterFrame", label )
end

local function dragListener( self, event )
	local phase = event.phase
 
    if( phase == "began" ) then
	    display.getCurrentStage():setFocus(self,event.id)
		self.isFocus = true
		-- Use this code to set joint in middle of object
		--self.tempJoint = physics.newJoint( "touch", self, self.x, self.y )

		-- Use this code to set joint at touch point
		self.tempJoint = physics.newJoint( "touch", self, event.x, event.y )

		self.tempJoint.maxForce = touchJointForce
	
	elseif( self.isFocus ) then

		if( phase == "moved" ) then
			self.tempJoint:setTarget( event.x, event.y )

		elseif( phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false

			display.remove( self.tempJoint ) 
		end			
    end 
    return true
end


-- ==
--		addDragger() - EFM
-- ==
function helpers.addDragger( obj )
	obj.touch = dragListener
	obj:addEventListener( "touch", obj )
	obj:setFillColor(0,1,0)
	obj.strokeWidth = 1	
	obj:setStrokeColor(1,0,1)
end

return helpers