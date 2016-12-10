-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================


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

	table.dump(obj)
end

--
-- Safely remove any current (table) touch listener attached to this object
function public.detach( obj )
	--
	-- Abort if obj is not a valid display object
	if( not obj or obj.removeSelf == nil ) then return end 

	table.dump(obj)
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
	-- Destroy the object when the touch ends
	if( event.phase == "ended" ) then
	   display.remove(self)
	end

	--
	-- Always return true for this example so Corona knows we 'processed' the touch
	return true
end


--
-- Return a reference to the module (table)
return public