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
-- Adopted from http://developer.coronalabs.com/code/color-transition-wrapper with fixes.
-- =============================================================
--Description:
--      This is a wrapper for changing fill color within a transition
--  Time, delay and easing values are optional
--
--Usage:
-- 
-- transition.fromtocolor(displayObject, colorFrom, colorTo, [time], [delay], [easing]) ;
-- ex:
--  
--  local rect = display.newRect(0,0,250,250) ;
--      local white = {1,1,1}     
--  local red = {1,0,0} ;
--      
--  transition.fromtocolor(rect, white, red, 1200) ;
-- =============================================================

--Local reference to transition function
transition.callback = transition.to ;
 
 
function transition.fromtocolor(obj, colorFrom, colorTo, time, delay, ease)
        
    local _obj =  obj ; 
    local ease = ease or easing.linear
    
    
    local fcolor = colorFrom or {1,1,1,1} ; -- defaults to white
    local tcolor = colorTo or {0,0,0,1} ; -- defaults to black
    local t = nil ;
    local p = {} --hold parameters here
    local rDiff = tcolor[1] - fcolor[1] ; --Calculate difference between values
    local gDiff = tcolor[2] - fcolor[2] ;
    local bDiff = tcolor[3] - fcolor[3] ;
    local aDiff = tcolor[4] - fcolor[4] ;
    
            --Set up proxy
    local proxy = {step = 0} ;

	local mt

	if( obj and obj.setFillColor ) then
		mt = {
				__index = function(t,k)
						--print("get") ;
						return t["step"] 
				end,
            
				__newindex = function (t,k,v)
						--print("set") 
						--print(t,k,v)
						if(_obj.setFillColor) then
								_obj:setFillColor(fcolor[1] + (v*rDiff) ,fcolor[2] + (v*gDiff) ,fcolor[3] + (v*bDiff), fcolor[4] + (v*aDiff) ) 
						end
						t["step"] = v ;
                    
                    
				end
            
		}		
	else
		 mt = {
				__index = function(t,k)
						--print("get") ;
						return t["step"] 
				end,
            
				__newindex = function (t,k,v)
						--print("set") 
						--print(t,k,v)
						if(_obj.setFillColor) then
								_obj:setFillColor(fcolor[1] + (v*rDiff) ,fcolor[2] + (v*gDiff) ,fcolor[3] + (v*bDiff), fcolor[4] + (v*aDiff) ) 
						end
						t["step"] = v ;
                    
                    
				end
            
		}
	end
    
    p.time = time or 1000 ; --defaults to 1 second
    p.delay = delay or 0 ;
    p.transition = ease ;

    setmetatable(proxy,mt) ;
    
    p.colorScale = 1 ;
    
    t = transition.to(proxy,p , 1 )  ;

    return t
end

 
 
 