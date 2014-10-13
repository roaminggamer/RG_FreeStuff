-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- transition Add-ons
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

 
 
 