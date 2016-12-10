-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

local listenerModule3 = require "touchListener3"

--
-- Create a table to hold our functions (this is the module)
local public = {}

--
-- Helper function to attach our listener to the 'object'
function public.attach( obj )
	--
	-- Abort if obj is not a valid display object
	if( not obj or obj.removeSelf == nil ) then return end 

	--
	-- Detach first, just in case we have one already on the object (makes our code more modular and safer.)
	public.detach( obj )

	--
	-- Attach the local listener defined by this module
	obj.touch = public.onTouch
	obj:addEventListener( "touch" )

end

--
-- Safely remove any current (table) touch listener attached to this object
function public.detach( obj )
	--
	-- Abort if obj is not a valid display object
	if( not obj or obj.removeSelf == nil ) then return end 

	--
	-- If this object has a (table) touch listener, remove it safely.
	if( obj.touch ) then
		obj:removeEventListener( "touch" )
		obj.touch = nil
	end
end

--
-- Define a simple (table) touch listener
function public.onTouch( self, event )
	--
	-- Abort if obj is not a valid display object
	if( not self or self.removeSelf == nil ) then return end 

	--
	-- Change color of object to 'RED' when the touch ends and replace the listener
	if( event.phase == "ended" ) then
	   self:setFillColor( 1, 0, 0 )

	   --
	   -- wait til the next frame to attach a new listener, OR it will get called immediately
	   timer.performWithDelay( 1, function() listenerModule3.attach( self ) end )
	end

	--
	-- Always return true for this example so Corona knows we 'processed' the touch
	return true
end


--
-- Return a reference to the module (table)
return public