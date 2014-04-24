-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Timer Add-ons
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
-- Adapted from: http://developer.coronalabs.com/code/timer-functions
-- =============================================================
 
-- Cache the original functions
timer.__performWithDelay = timer.performWithDelay
timer.__pause = timer.pause
timer.__resume = timer.resume
timer.__cancel = timer.cancel
 
timer.performWithDelay = function( s, f, __resume )
        local t = timer.__performWithDelay( s, f, __resume )
        t.status = true
        return t
end
 
timer.pause = function( id )
        id.status = false
        return timer.__pause( id )
end
 
timer.resume = function( id )
        id.status = true
        return timer.__resume( id )
end
 
timer.cancel = function( id )
        id.status = nil
        return timer.__cancel( id )
end
 
-- return the status of a timer
-- true: timer is running
-- false: timer is paused
-- nil: timer is cancelled
timer.getStatus = function( id )
        return id.status
end