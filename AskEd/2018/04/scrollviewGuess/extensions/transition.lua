-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- transition.* - Extension(s)
-- =============================================================
-- =============================================================
-- Adapted from http://developer.coronalabs.com/code/color-transition-wrapper with fixes.
-- =============================================================
-- Description:
-- This is a wrapper for changing fill color within a transition
-- Time, delay and easing values are optional
--
-- Usage:
-- transition.color(displayObject, fromColor, toColor, [time], [delay], [easing])
--
-- ex:
-- local rect = display.newRect(0,0,250,250)
-- local white = {1,1,1}     
-- local red = {1,0,0}
--      
--  transition.color(rect, white, red, 1200)
-- =============================================================
 function transition.color( obj, params )
 	params = params or {}
 	--table.dump(params)
 	local fromColor 	= params.fromColor or _W_
 	local toColor 		= params.toColor or _W_
 	local time 			= params.time or 1000
 	local delay 		= params.delay
 	local ease 			= params.transition
 	local onComplete 	= params.onComplete

 	-- Handle case where reference to obj is passed with
 	-- 'onComplete' method attached
 	if( onComplete and type(onComplete) == "table" ) then
 		onComplete = onComplete.onComplete 
 	end

   local fcolor 	= table.shallowCopy( fromColor )
   local tcolor 	= table.shallowCopy( toColor )
   fcolor[4] 	= fcolor[4] or 1
   tcolor[4] 		= tcolor[4] or 1 
   
   local t = nil
   local p = {}
   
   local rDiff = tcolor[1] - fcolor[1]
   local gDiff = tcolor[2] - fcolor[2]
   local bDiff = tcolor[3] - fcolor[3]
   local aDiff = tcolor[4] - fcolor[4]
    
   --Set up proxy
   local proxy = {step = 0}

	local mt

	if( obj and obj.setFillColor ) then
		mt = 
		{
			__index = function(t,k)
				return t["step"] 
			end,
         
			__newindex = function (t,k,v)
				if(obj.setFillColor) then
					obj:setFillColor(fcolor[1] + (v*rDiff) ,fcolor[2] + (v*gDiff) ,fcolor[3] + (v*bDiff), fcolor[4] + (v*aDiff) ) 
				end
				t["step"] = v
			end
		}		
	else
		mt = 
		{
			__index = function(t,k)
				return t["step"] 
			end,

			__newindex = function (t,k,v)
				if(obj.setFillColor) then
					obj:setFillColor(fcolor[1] + (v*rDiff) ,fcolor[2] + (v*gDiff) ,fcolor[3] + (v*bDiff), fcolor[4] + (v*aDiff) ) 
				end
				t["step"] = v
			end
		}
	end    
    p.time = time or 1000
    p.delay = delay or 0
    p.transition = ease or easing.linear

    if( onComplete ) then
    	p.onComplete = function( )
    		onComplete( obj )
    	end
    end 
    setmetatable(proxy,mt)
    p.colorScale = 1

    t = transition.to(proxy,p)
    return t
end

 
 
 