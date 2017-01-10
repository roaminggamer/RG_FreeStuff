rooms.add( 'start', 'Wizard Isle', 'Beach', 
	        "You are standing on a beach.  A rocky #trail#trail1 leads #north#room1 towards some cliffs.  To the #west#room2 you see a shack.  ",
			{ "seashell1" } )


rooms.add( 'room1', 'Wizard Isle', 'Cliffs', 
			"A small clearing rests at the base of impassible cliffs.  A rocky #trail#trail2 leads #south#start towards the ocean.  A grassy path leads uphill to the #west#room3.  ",
			nil )

rooms.add( 'room2', 'Wizard Isle', 'Shack', 
			"A small shack with a single #door#shackdoor and a #window#shackwindow sits all alone on the edge of the island.  The door is closed.  Trails lead #north#room3 and #east#start.  ",
			nil )

rooms.add( 'room3', 'Wizard Isle', 'Hilltop', 
			"You stand atop a low hill.  To the #east#room1 you see a grassy clearing.  To the #south#room2 is a shack.  A loose and rutted trail leads #southeast#start.  ",
			nil )

rooms.add( 'shackdoor', 'Wizard Isle', 'Shack', 
			"You open the door, and see a crossbow resting on a table and facing the door.  You also see a string, attaching the the crossbow's trigger to the doorknob... Twang!  Oomph!You died.  ",
			nil )

rooms.add( 'shackwindow', 'Wizard Isle', 'Shack', 	
			"The window is too dirty to see through.  If you could break the window, you would be able to look inside.  Oh well, there is always the door.  ",
			nil )

local function trail1( obj, target, word, room )
	return "Function test worked! " .. target .. " " .. word .. " " .. room
end

local function seashell1( obj, target, word, room )
	return false, "Function test worked! " .. target .. " " .. word .. " " .. room
end

things.add( 'trail1', { "That looks pretty steep.  Are you sure you want to go that way?", "Maybe you should go that way.  Maybe not." } )
--things.add( 'trail1', trail1 )
things.add( 'trail2',  "Wow, that is steep.  Watch your step if you go that way." )

-- Objects
objects.add( 'seashell1', 'seashell', "You notice it has a very pleasing spiral shape." )
--objects.add( 'seashell1', 'seashell', { "Descr 1", "Descr 2" } )
--objects.add( 'seashell1', 'seashell', seashell1 )
objects.add( 'rock1', 'rock', "That a useful looking rock." )


