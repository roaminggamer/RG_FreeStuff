-- Wizard Isle - Beach Area
--
--[[
rooms.add ( 'beachA', 'Wizard Isle', 'Beach', 
	"You are standing on a beach.  #trail#trail1" ..
	"#west#shack #north#clearingA #east#holes",
	{ "seashell1" }  )


rooms.add ( 'shack', 'Wizard Isle', 'Outside a Shack', 
	"There is a shack here." ..
	"#east#beachA #north#hill",
	{} )

rooms.add ( 'hill', 'Wizard Isle', 'A Hill', 
	"You are standing at the top of a hill." ..
	"#south#shack #southeast#beachA #east#clearingA",
	{} )

rooms.add ( 'clearingA', 'Wizard Isle', 'A Clearing', 
	"You are standing in a clearing." ..
	"#west#hill #south#beachA #northeast#defile",
	{} )

rooms.add ( 'defile', 'Wizard Isle', 'A Path Through The Cliffs', 
	"Yada yada " ..
	"#southwest#clearingA",
	{} )


rooms.add ( 'holes', 'Wizard Isle', 'Some Odd Holes', 
	"You are standing on a beach.  There are odd holes here " ..
	"#west#beachA #northeast#beachB",
	{} )


rooms.add ( 'beachB', 'Wizard Isle', 'Eastern Beach', 
	"You are standing on a beach at the eastern most edge of the island.  You can just see a ship and what looks like docks to the far north." ..
	"#southwest#holes #west#cave",
	{} )


rooms.add ( 'cave', 'Wizard Isle', 'A Shallow Cave', 
	"You are standing in a shallow cave." ..
	"#east#beachB",
	{} )

--]]



--things.add( 'trail1', { "That looks pretty steep.  Are you sure you want to go that way?", "Maybe you should go that way.  Maybe not." } )
--things.add( 'trail1', trail1 )

--
--==Add Rooms
--

rooms.add ( 'beachA', 'Wizard Isle', 'Beach', 
	"You are standing on a beach.<br>" ..
	"A rocky #trail#trail1 leads #north#room1 towards some cliffs.<br>" ..
	"To the #west#room2 you see a shack.  The beach continues to the #east#holes.",
	{ "seashell1" } 
)

rooms.add( 'room1', 'Wizard Isle', 'Small Clearing', 
			"A small clearing rests at the base of a steep cliff." .. 
			"A rocky #trail#trail2 leads #south#beachA towards the ocean." ..
			"A grassy path leads uphill to the #west#room3.  A narrow path leads #northeast#split to a split in the cliff face.",
			{} )

rooms.add( 'split', 'Wizard Isle', 'Split in Cliff Face', 
			"You stand in a narrow split in the cliff face.  Tall #walls#inscriptions of rock rise on either side." ..
			"You can continue due #north#gate along a #muddy#path or return the the #southwest#room1.",
			{} )

rooms.add( 'gate', 'Wizard Isle', 'Poles', 
			"At the end of the split, the trail ends abruptly.  You find two strange #poles#poles sticking out of the #ground#." ..
			"You can't advance any further, but you can go back to the #south#split.",
			{} )

rooms.add( 'room2', 'Wizard Isle', 'Shack', 
			"A small shack with a single #door#shackdoor and a #window#shackwindow sits all alone on the edge of the island." ..
			"The door is closed.  Trails lead #north#room3 and #east#beachA.",
			{} )

rooms.add( 'room3', 'Wizard Isle', 'Hilltop', 
			"You stand atop a low hill.  To the #east#room1 you see a grassy clearing." ..
			"To the #south#room2 is a shack.  A loose and rutted trail leads #southeast#beachA.",
			{} )

rooms.add( 'shackdoor', 'Wizard Isle', 'Shack', 
			"You open the door, and see a crossbow resting on a table and facing the door." ..
			"You also see a string, attaching the the crossbow's trigger to the doorknob... Twang!  Oomph!You died.  ",
			{} )

rooms.add( 'shackwindow', 'Wizard Isle', 'Shack', 	
			"The window is too dirty to see through." ..
			"If you could break the window, you would be able to look inside.  Oh well, there is always the door.",
			{} )

rooms.add ( 'holes', 'Wizard Isle', 'Strange Holes', 
	"There are some #strange_holes#beachholes in the beach here." ..
	"The beach extends to the #west#beachA and curves around to the #northeast#beachB",
	{} 
)

rooms.add ( 'beachB', 'Wizard Isle', 'Eastern Beach', 
	"You are standing on a beach at the eastern most edge of the island." ..
	"You can just see a ship and what looks like docks to the far north." ..
	"The beach leads back to the #southwest#holes.  There is also a faint trail leading #west#cave.",
	{} )


rooms.add ( 'cave', 'Wizard Isle', 'A Shallow Cave', 
	"You are standing in a shallow cave." ..
	"#east#beachB",
	{} )


things.add( 'beachholes',  "Yep.  Those are holes...in the beach." )

things.add( 'trail1', { "That looks pretty steep.  Are you sure you want to go that way?", 
	                    "Maybe you should go that way.  Maybe not." } )
things.add( 'trail2',  "Wow, that is steep.  Watch your step if you go that way." )
objects.add( 'seashell1', 'seashell', "You notice it has a very pleasing spiral shape." )
objects.add( 'rock1', 'rock', "That a useful looking rock." )

--[[

local thingFunc = {}
thingFunc.getDescription = function( self, obj, target, word, room )
	return "Thing Func Get Description Test Worked!"
end
funcs.add( 'trail1', thingFunc)

things.add( 'trail1', 'function' )


local thingFunc2 = {}
thingFunc2.getDescription = function( self, obj, target, word, room )
	return true, "Thing Func Get Description2 Test Worked!"
end
thingFunc2.getShort = function( self, target, room )
	return "Glowing_Seashell"
end
funcs.add( 'seashell1', thingFunc2)

objects.add( 'seashell1', 'seashell', "function" )


local thingFunc3 = {}
thingFunc3.getDescription = function( self )
	return "BOOYA You are standing on a beach.  #trail#trail1" ..
				 "#west#shack #north#clearingA #east#holes"
end
funcs.add( 'beachA', thingFunc3 )

rooms.add ( 'beachA', 'Wizard Isle', 'Beach', 
	"function",
	{ "seashell1" }  )
--]]