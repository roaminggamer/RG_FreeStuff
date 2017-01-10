
--
--==Add Rooms
--
rooms.add ( 'wi_beach_start', 'Wizard Isle', 'Beach', 
	"You are standing on a lonely beach." ..
	"<br>A rocky #trail#wi_beach_trail1 leads #north#wi_beach_clearing towards some cliffs." ..
	"<br>To the #west#wi_beach_shack you see a shack.<br>The beach continues without interruption to the #east#wi_beach_holes.",
	{} )

rooms.add( 'wi_beach_trail1', 'Wizard Isle', 'Rocky Trail', 
			"You look closely at the rocky trail and see a fist sized rock." ..
			"<br>#Back#wi_beach_start",
			{ "wi_beach_rock1" } )


rooms.add( 'wi_beach_clearing', 'Wizard Isle', 'Small Clearing', 
			"A small clearing rests at the base of a steep cliff." .. 
			"<br>A rocky #trail#wi_beach_trail2 leads #south#wi_beach_start towards the ocean." ..
			"<br>A grassy path leads uphill to the #west#wi_beach_hilltop." ..
			"<br>It looks like there may be a split in the face of the cliff to the #northeast#wi_beach_split.",
			{} )

rooms.add( 'wi_beach_trail2', 'Wizard Isle', 'Rocky Trail', 
			"You look closely at the rocky trail and see a fist sized rock." ..
			"<br>#Back#wi_beach_clearing",
			{ "wi_beach_rock1" } )

rooms.add( 'wi_beach_split', 'Wizard Isle', 'Split in Cliff Face', 
			"You stand in a narrow split in the cliff face." ..
			"<br>Tall #walls#inscriptions of rock rise on either side." ..
			"You can continue due #north#gate along a #muddy#path or " ..
			"return the the #southwest#wi_beach_clearing.",
			{} )

rooms.add( 'inscriptions', 'Wizard Isle', 'Inscriptions', 
			"Description of inscriptions goes here." ..
			"<br>#Back#wi_beach_split",
			{} )



rooms.add( 'gate', 'Wizard Isle', 'Poles', 
			"At the end of the wi_beach_split, the trail ends abruptly." ..
			"<br>You find two strange #poles#poles sticking out of the #ground#." ..
			"<br>You can't advance any further, but you can go back to " ..
			"the #south#wi_beach_split.",
			{} )

rooms.add( 'wi_beach_shack', 'Wizard Isle', 'Shack', 
			"A small shack with a single #door#wi_beach_shackdoor and a #window#wi_beach_shackwindow " ..
			"sits all alone on the edge of the island." ..
			"The door is closed." ..
			"<br>The only exit is #east#wi_beach_start.",
			{} )

rooms.add( 'wi_beach_hilltop', 'Wizard Isle', 'Hilltop', 
			"You stand atop a low hill.  There is a raised #round_platform#wi_beach_teleport here." ..
			"It is inscribed with runes and odd patterns." ..
			"<br>To the #east#wi_beach_clearing you see a grassy clearing." ..
			"<br>A loose rutted path leads down to the #southeast#wi_beach_start." ..
			"<br>Far to the south you see a shack, but there is no way to reach it from here.  ",
			{} )

rooms.add( 'wi_beach_shackdoor', 'Wizard Isle', 'Shack', 
			"The door swings open slowly." ..
			"<br>You see a crossbow resting on a table opposite the door." ..
			"<br>The trigger on the crossbow is connected to the door by a taut string." ..
			"<br>" ..
			"Twang!  Oomph! You died.",
			{} )

rooms.add( 'wi_beach_shackwindow', 'Wizard Isle', 'Shack', 	
			"The window is too dirty to see through." ..
			"If you could break the window, you would be able to look inside.  " ..
			"Oh well, there is always the door.",
			{} )

rooms.add ( 'wi_beach_holes', 'Wizard Isle', 'Strange Holes', 
	"There are some #strange_holes#wi_beach_beachholes in the beach here." ..
	"<br>The beach extends to the #west#wi_beach_start and curves around to " ..
	"the #northeast#wi_beach_beachB",
	{} 
)

rooms.add ( 'wi_beach_beachB', 'Wizard Isle', 'Eastern Beach', 
	"You are standing on a beach at the eastern-most edge of the island." ..
	"<br>You can just see a ship and what looks like docks to the far north." ..
	"<br>The beach leads back to the #southwest#wi_beach_holes.  There is also a " ..
			"faint trail leading #west#wi_beach_cave.",
	{} )

rooms.add ( 'wi_beach_cave', 'Wizard Isle', 'A Shallow Cave', 
	"You are standing in a shallow cave." ..
	"<br>The only exit leads #east#wi_beach_beachB.", 
	{ "wi_beach_brokenboard" } )

things.add( 'wi_beach_beachholes',  "Yep.  Those are wi_beach_holes...in the beach." )

--things.add( 'wi_beach_trail1', { "That looks pretty steep.  Are you sure you want to go that way?", 
--	                    "Maybe you should go that way.  Maybe not." } )
--things.add( 'wi_beach_trail2',  "Wow, that is steep.  Watch your step if you go that way." )
objects.add( 'wi_beach_seashell2', 'seashell', "You notice it has a very pleasing spiral shape." )
objects.add( 'wi_beach_rock1', 'rock', "That a useful looking rock." )
objects.add( 'wi_beach_coin1', 'coin', "That a useful looking coin" )
objects.add( 'wi_beach_brokenboard', 'broken_board', "The board is roughly shaped like a shovel."..
	"<br>You might be able to use it for digging at those holes in the beach." )
