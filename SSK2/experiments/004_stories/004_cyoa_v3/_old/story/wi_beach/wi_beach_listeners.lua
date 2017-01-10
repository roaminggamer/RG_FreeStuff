-- before_
-- after_ 

local function before_wi_beach_start( event )
	table.dump(event)
	if( rooms.hasObject( 'wi_beach_trail1', 'wi_beach_rock1' ) == false or 
		   rooms.hasObject( 'wi_beach_trail2', 'wi_beach_rock1' ) == false ) then

		rooms.setDescription( 'wi_beach_start',
			"You are standing on a lonely beach." ..
			"<br>A rocky trail leads #north#wi_beach_clearing towards some cliffs." ..
			"<br>To the #west#wi_beach_shack you see a shack.<br>The beach continues without interruption to the #east#wi_beach_holes."
			)

		rooms.setDescription( 'wi_beach_clearing',
			"A small clearing rests at the base of a steep cliff." .. 
			"<br>A rocky trail leads #south#wi_beach_start towards the ocean." ..
			"<br>A grassy path leads uphill to the #west#wi_beach_hilltop." ..
			"<br>It looks like there may be a split in the face of the cliff to the #northeast#wi_beach_split."
			)
	end
end
local function before_wi_beach_clearing( event )
	before_wi_beach_start( event )
end


local function init()
	listen( "before_wi_beach_start", before_wi_beach_start )
	listen( "before_wi_beach_clearing", before_wi_beach_clearing )
end

local function destroy()
	ignore( "before_wi_beach_start", before_wi_beach_start )
	ignore( "before_wi_beach_clearing", before_wi_beach_clearing )
end


local public = {}
public.init = init
public.destroy = destroy
return public