-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Game Logic Modules
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

local components

if( not _G.ssk.components ) then
	_G.ssk.components = {}
end

components = _G.ssk.components

-- ==
--    func() - what it does
-- ==
function components.addDrag( obj, params )

	local params = params 
	if(not params) then params = {} end

	-- Initialize parameters
	if( params.minDropDistance) then
		params.minDropDistance2 = params.minDropDistance *  params.minDropDistance 
	end

	local onDrag

	if( params.usePhysics ) then
		-- ==
		--    NON-PHYSICS DRAG HANDLER
		-- ==
		onDrag = function ( event ) 

			local phase  = event.phase
			local target = event.target
			local x      = event.x
			local y      = event.y
			local stage = display.getCurrentStage()

			if( phase == "began" ) then
				stage:setFocus( target, event.id )
				target.isFocus = true
			
				if( params and params.center ) then
					-- drag the target from its center point
					target.__tmpJoint = physics.newJoint( "touch", target, target.x, target.y )
				else
					-- drag the target from the point where it was touched
					target.__tmpJoint = physics.newJoint( "touch", target, event.x, event.y )
				end

				-- Apply optional joint parameters
				local maxForce, frequency, dampingRatio

				if(params.maxForce) then
					-- Internal default is (1000 * mass), so set this fairly high if setting manually
					target.__tmpJoint.maxForce = params.maxForce
				end
			
				if(params.frequency)then
					-- This is the response speed of the elastic joint: higher numbers = less lag/bounce
					target.__tmpJoint.frequency = params.frequency
				end
			
				if(params.dampingRatio)then
					-- Possible values: 0 (no damping) to 1.0 (critical damping)
					target.__tmpJoint.dampingRatio = params.dampingRatio
				end

				if(params.onBegan) then
					local event = table.shallowCopy(event)
					params.onBegan( event )
				end
	
			elseif(target.isFocus) then
				if( phase == "moved" ) then
					-- Update the joint to track the touch
					target.__tmpJoint:setTarget( event.x, event.y )

					if(params.minDropDistance) then
						-- Check to see if touch is too far away (if so, let go of object)
						local dx = target.x - event.x
						local dy = target.y - event.y
						local len2 = dx * dx + dy * dy

						print(len2, params.minDropDistance2)
						if(len2 >= params.minDropDistance2 ) then
							stage:setFocus( target, nil )
							target.isFocus = false
							target.__tmpJoint:removeSelf()
						end
					end

					if(params.onDragged) then
						local event = table.shallowCopy(event)
						params.onDragged( event )
					end

				else
					stage:setFocus( target, nil )
					target.isFocus = false
					-- Remove the joint when the touch ends			
					target.__tmpJoint:removeSelf()

					if(params.onDropped) then
						local event = table.shallowCopy(event)
						params.onDropped( event )
					end
				end
			else
				return false
			end

			return true
		end
	else
		-- ==
		--    NON-PHYSICS DRAG HANDLER
		-- ==
		onDrag = function ( event ) 
			local phase  = event.phase
			local target = event.target
			local x      = event.x
			local y      = event.y

			if(phase == "began") then
				display.getCurrentStage():setFocus( target, event.id )
				target.isFocus = true
				if(params.snap) then
					target.x = x
					target.y = y
				else
					target.__dragLastX = x
					target.__dragLastY = y
				end

				if(params.onBegan) then
					local event = table.shallowCopy(event)
					params.onBegan( event )
				end

				-- Because snapping is also a drag,...
				if(params.snap and params.onDragged) then
					local event = table.shallowCopy(event)
					params.onDragged( event )
				end

			elseif( target.isFocus ) then

				if(phase == "moved") then
					if(params.snap) then
						target.x = x
						target.y = y
					else
						target.__dragDeltaX = x - target.__dragLastX
						target.__dragDeltaY = y - target.__dragLastY
						target.__dragLastX  = x
						target.__dragLastY  = y
						target.x            = target.x + target.__dragDeltaX
						target.y            = target.y + target.__dragDeltaY
					end

					if(params.onDragged) then
						local event = table.shallowCopy(event)
						params.onDragged( event )
					end

				else
					display.getCurrentStage():setFocus( target, nil )
					target.isFocus = false

					if(params.snap) then
						target.x = x
						target.y = y
					else
						target.__dragDeltaX = x - target.__dragLastX
						target.__dragDeltaY = y - target.__dragLastY
						target.__dragLastX  = x
						target.__dragLastY  = y
						target.x            = target.x + target.__dragDeltaX
						target.y            = target.y + target.__dragDeltaY
					end

					if(params.onDropped) then
						local event = table.shallowCopy(event)
						params.onDropped( event )
					end
			
				end
			else
				print("What!")
				return false
			end

			return true
		end
	end

	-- Attach drag handler
	obj:addEventListener( "touch", onDrag )

	-- ==
	--    func() - what it does
	-- ==
	obj.removeDrag = function( self )
		print("Goodbye onDrag")
		obj:removeEventListener( "touch", onDrag ) 
	end

	ssk.advanced.addCustom_removeSelf( obj, obj.removeDrag )

end
