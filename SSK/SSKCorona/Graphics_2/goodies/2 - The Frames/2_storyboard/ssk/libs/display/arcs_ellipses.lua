-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Prototyping Objects
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

-- Create the display class if it does not yet exist
--
local displayExtended
if( not _G.ssk.display ) then
	_G.ssk.display = {}
end
displayExtended = _G.ssk.display

local mCos = math.cos
local mSin = math.sin

-- ==
--    func() - what it does
-- ==
function displayExtended.arc(group, x,y,w,h,s,e,rot) -- modification of original code by: rmbsoft (Corona Forums Member)
	local group = group or display.currentStage
	local theArc = display.newGroup()

	local xc,yc,xt,yt = 0,0,0,0
	s,e = s or 0, e or 360
	s,e = math.rad(s),math.rad(e)
	w,h = w/2,h/2
	local l = display.newLine(0,0,0,0)
	if(rot == 0) then
		l:setStrokeColor(1, 0, 0)
	else
		l:setStrokeColor(0, 1, 0)
	end
	l.strokeWidth = 4
                
	theArc:insert( l )
		
	for t=s,e,0.02 do 
		local cx,cy = xc + w*mCos(t), yc - h*mSin(t)
		l:append(cx,cy) 
	end

	group:insert( theArc )

	-- Center, Rotate, then translate		
	theArc.x,theArc.y = 0,0
	theArc.rotation = rot
	theArc.x,theArc.y = x,y
			
	return theArc
end
        
-- ==
--    func() - what it does
-- ==
function displayExtended.ellipse(group, x, y, w, h, rot) -- modification of original code by: rmbsoft (Corona Forums Member)
	local group = group or display.currentStage
	return displayExtended.arc(group, x, y, w, h, nil, nil, rot)
end

