local mRand 	= math.random

local function genPoints( num )
	local tmp = {}
	for i = 1, num do
		local x, y = mRand(10, 470), mRand( 10, 310 )

		-- Keep points out of center area (for nicer example)
		while(( x > 200 and x < 280 ) and (y > 120 and y < 200)) do
			x = mRand(10, 470)
			y = mRand( 10, 310 )
		end

		tmp[i] = { x, y }
	end
	return tmp
end

local function createTargets( points )
	local targets = {}
	for i = 1, #points do
		local tmp = display.newCircle( points[i][1], points[i][2], 3 )
		targets[i] = tmp
	end
	return targets
end

local function createTargets2( points )
	local targets = {}
	for i = 1, #points do
		local tmp = display.newCircle( points[i][1], points[i][2], 3 )
		targets[tmp] = tmp
	end
	return targets
end

local function onComplete( self, event )
	display.remove(self.target)
	display.remove(self)
	return true
end

local function shootTarget( x0, y0, target, time )	
	local tmp = display.newCircle( x0, y0, 3 )
	tmp:setFillColor(1,0,0)

	tmp.target = target
	
	transition.to( tmp, { x = target.x, y = target.y, time = time, onComplete = onComplete } )	

end

local function drawLine2Target( x0, y0, target )	
	local tmp = display.newLine( x0, y0, target.x, target.y )
	tmp:setStrokeColor(1,0,0)
	tmp:toBack()
end


local public = {}
public.genPoints 		= genPoints
public.createTargets 	= createTargets
public.createTargets2 	= createTargets2
public.shootTarget 		= shootTarget
public.drawLine2Target	= drawLine2Target

return public